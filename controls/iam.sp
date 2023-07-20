locals {
  conformance_pack_iam_common_tags = merge(local.aws_top_10_common_tags, {
    service = "AWS/IAM"
  })
}

control "iam_user_one_active_key" {
  title         = "Ensure there is only one active access key available for any single IAM user"
  description   = "Access keys are long-term credentials for an IAM user or the AWS account root user. You can use access keys to sign programmatic requests to the AWS CLI or AWS API (directly or using the AWS SDK)."
  query         = query.iam_user_one_active_key

  tags = local.conformance_pack_iam_common_tags
}

control "iam_access_analyzer_enabled" {
  title         = "Ensure that IAM Access analyzer is enabled for all regions"
  description   = "Enable IAM Access analyzer for IAM policies about all resources in each region. IAM Access Analyzer is a technology introduced at AWS reinvent 2019. After the Analyzer is enabled in IAM, scan results are displayed on the console showing the accessible resources. Scans show resources that other accounts and federated users can access, such as KMS keys and IAM roles. So the results allow you to determine if an unintended user is allowed, making it easier for administrators to monitor least privileges access. Access Analyzer analyzes only policies that are applied to resources in the same AWS Region."
  query         = query.iam_access_analyzer_enabled

  tags = local.conformance_pack_iam_common_tags
}

control "iam_root_user_virtual_mfa" {
  title         = "IAM root user virtual MFA should be enabled"
  description   = "Enable this rule to restrict access to resources in the AWS Cloud."
  query         = query.iam_root_user_virtual_mfa

  tags = local.conformance_pack_iam_common_tags
}

query "iam_user_one_active_key" {
  sql = <<-EOQ
    select
      u.arn as resource,
      case
        when count(k.*) > 1 then 'alarm'
        else 'ok'
      end as status,
      u.name || ' has ' || count(k.*) || ' active access key(s).' as reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "u.")}
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "u.")}
    from
      aws_iam_user as u
      left join aws_iam_access_key as k on u.name = k.user_name and u.account_id = k.account_id
    where
      k.status = 'Active' or k.status is null
    group by
      u.arn,
      u.name,
      u.account_id,
      u.tags,
      u._ctx;
  EOQ
}

query "iam_access_analyzer_enabled" {
  sql = <<-EOQ
    select
      'arn:' || r.partition || '::' || r.region || ':' || r.account_id as resource,
      case
        -- Skip any regions that are disabled in the account.
        when r.opt_in_status = 'not-opted-in' then 'skip'
        when aa.arn is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when r.opt_in_status = 'not-opted-in' then r.region || ' region is disabled.'
        when aa.arn is not null then aa.name ||  ' enabled in ' || r.region || '.'
        else 'Access Analyzer not enabled in ' || r.region || '.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "r.")}
    from
      aws_region as r
      left join aws_accessanalyzer_analyzer as aa on r.account_id = aa.account_id and r.region = aa.region;
  EOQ
}

query "iam_root_user_virtual_mfa" {
  sql = <<-EOQ
    select
      'arn:' || s.partition || ':::' || s.account_id as resource,
      case
        when account_mfa_enabled and serial_number is not null then 'ok'
        else 'alarm'
      end status,
      case
        when account_mfa_enabled = false then 'MFA is not enabled for the root user.'
        when serial_number is null then 'MFA is enabled for the root user, but the MFA associated with the root user is a hardware device.'
        else 'Virtual MFA enabled for the root user.'
      end reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "s.")}
    from
      aws_iam_account_summary as s
      left join aws_iam_virtual_mfa_device on serial_number = 'arn:' || s.partition || ':iam::' || s.account_id || ':mfa/root-account-mfa-device';
  EOQ
}