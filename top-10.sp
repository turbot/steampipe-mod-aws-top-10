benchmark "aws_top_10_security" {
  title       = "AWS Security Top 10"
  description = "The top 10 AWS security items recommended on the AWS Security blog."

  children = [
    benchmark.aws_top_10_security_accurate_account_info,
    benchmark.aws_top_10_security_use_mfa,
    benchmark.aws_top_10_security_no_secrets,
    benchmark.aws_top_10_security_limit_security_groups,
    benchmark.aws_top_10_security_intentional_data_policies,
    benchmark.aws_top_10_security_centralize_cloudtrail_logs,
    benchmark.aws_top_10_security_validate_iam_roles,
    benchmark.aws_top_10_security_take_action_on_findings,
    benchmark.aws_top_10_security_rotate_keys
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_accurate_account_info" {
  title = "1. Accurate account information"
  description = "When AWS needs to contact you about your AWS account, we use the contact information defined in the AWS Management Console, including the email address used to create the account and those listed under Alternate Contacts."
  children = [
    aws_compliance.control.cis_v120_1_18
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_use_mfa" {
  title = "2. Use multi-factor authentication (MFA)"
  description = "MFA is the best way to protect accounts from inappropriate access. Always set up MFA on your Root user and AWS Identity and Access Management (IAM) users."
  children = [
    aws_compliance.control.iam_root_user_mfa_enabled,
    aws_compliance.control.iam_user_console_access_mfa_enabled,
    aws_compliance.control.iam_user_mfa_enabled
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_no_secrets" {
  title = "3. No hard-coding secrets"
  description = "When you build applications on AWS, you can use AWS IAM roles to deliver temporary, short-lived credentials for calling AWS services. However, some applications require longer-lived credentials, such as database passwords or other API keys. If this is the case, you should never hard code these secrets in the application or store them in source code."
  children = [
    aws_compliance.control.cloudformation_stack_output_no_secrets,
    aws_compliance.control.ec2_instance_user_data_no_secrets,
    aws_compliance.control.ecs_task_definition_container_environment_no_secret
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_limit_security_groups" {
  title = "4. Limit security groups"
  description = "Security groups are a key way that you can enable network access to resources you have provisioned on AWS. Ensuring that only the required ports are open and the connection is enabled from known network ranges is a foundational approach to security."
  children = [
    aws_compliance.control.ec2_instance_no_launch_wizard_security_group,
    aws_compliance.control.vpc_security_group_allows_ingress_authorized_ports,
    aws_compliance.control.vpc_security_group_allows_ingress_to_cassandra_ports,
    aws_compliance.control.vpc_security_group_allows_ingress_to_memcached_port,
    aws_compliance.control.vpc_security_group_allows_ingress_to_mongodb_ports,
    aws_compliance.control.vpc_security_group_allows_ingress_to_oracle_ports,
    aws_compliance.control.vpc_security_group_restrict_ingress_kafka_port,
    aws_compliance.control.vpc_security_group_restrict_ingress_redis_port,
    aws_compliance.control.vpc_security_group_restricted_common_ports
]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_intentional_data_policies" {
  title = "5. Intentional data policies"
  description = "Not all data is created equal, which means classifying data properly is crucial to its security. It's important to accommodate the complex tradeoffs between a strict security posture and a flexible agile environment."
  children = [
    aws_compliance.control.foundational_security_s3_1,
    aws_compliance.control.foundational_security_s3_2,
    aws_compliance.control.foundational_security_s3_3,
    aws_compliance.control.foundational_security_s3_6,
    aws_compliance.control.s3_public_access_block_bucket_account,
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_centralize_cloudtrail_logs" {
  title = "6. Centralize CloudTrail logs"
  description = "Logging and monitoring are important parts of a robust security plan. Being able to investigate unexpected changes in your environment or perform analysis to iterate on your security posture relies on having access to data. AWS recommends that you write logs, especially AWS CloudTrail, to an S3 bucket in an AWS account designated for logging (Log Archive)."
  children = [
    aws_compliance.benchmark.foundational_security_cloudtrail,
    aws_compliance.control.foundational_security_cloudtrail_1,
    aws_compliance.control.foundational_security_cloudtrail_5,
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_validate_iam_roles" {
  title = "7. Validate IAM roles"
  description = "As you operate your AWS accounts to iterate and build capability, you may end up creating multiple IAM roles that you discover later you don't need."
  children = [
    aws_compliance.control.cis_v150_1_20,
    aws_compliance.control.iam_access_analyzer_enabled_without_findings,
    aws_perimeter.control.iam_role_trust_policy_prohibit_public_access
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_take_action_on_findings" {
  title = "8. Take action on findings"
  description = "AWS Security Hub, Amazon GuardDuty, and AWS Identity and Access Management Access Analyzer are managed AWS services that provide you with actionable findings in your AWS accounts. They are easy to turn on and can integrate across multiple accounts. Turning them on is the first step. You also need to take action when you see findings."
  children = [
    aws_compliance.control.cis_v150_4_16,
    aws_compliance.control.foundational_security_guardduty_1,
    aws_compliance.control.guardduty_no_high_severity_findings,
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_rotate_keys" {
  title = "9. Rotate keys"
  description = "If you need to use access keys rather than roles, you should rotate them regularly."
  children = [
    aws_compliance.control.cis_v120_1_12,
    aws_compliance.control.cis_v150_1_13,
    aws_compliance.control.cis_v150_1_14
  ]

  tags = local.aws_top_10_tags
}
