locals {
  account_security_common_tags = merge(local.aws_top_10_common_tags, {
    category = "Security"
    type     = "Benchmark"
  })
}

benchmark "account_security" {
  title       = "AWS Account Security Top 10"
  description = "The top 10 AWS account security items recommended on the AWS Security blog."
  documentation = file("./account_security/docs/account_security_overview.md")

  children = [
    benchmark.account_security_accurate_account_info,
    benchmark.account_security_use_mfa,
    benchmark.account_security_no_hardcoded_secrets,
    benchmark.account_security_limit_security_groups,
    benchmark.account_security_intentional_data_policies,
    benchmark.account_security_centralize_cloudtrail_logs,
    benchmark.account_security_validate_iam_roles,
    benchmark.account_security_take_action_on_findings,
    benchmark.account_security_rotate_keys,
    benchmark.account_security_dev_cycle
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_accurate_account_info" {
  title = "1. Accurate account information"
  description = "When AWS needs to contact you about your AWS account, we use the contact information defined in the AWS Management Console, including the email address used to create the account and those listed under Alternate Contacts."
  children = [
    control.account_alternate_contact_security_registered
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_use_mfa" {
  title = "2. Use multi-factor authentication (MFA)"
  description = "MFA is the best way to protect accounts from inappropriate access. Always set up MFA on your Root user and AWS Identity and Access Management (IAM) users."
  children = [
    aws_compliance.control.iam_root_user_mfa_enabled,
    aws_compliance.control.iam_user_console_access_mfa_enabled,
    aws_compliance.control.iam_user_mfa_enabled,
    aws_compliance.control.iam_user_with_administrator_access_mfa_enabled,
    control.iam_root_user_virtual_mfa
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_no_hardcoded_secrets" {
  title = "3. No hard-coding secrets"
  description = "When you build applications on AWS, you can use AWS IAM roles to deliver temporary, short-lived credentials for calling AWS services. However, some applications require longer-lived credentials, such as database passwords or other API keys. If this is the case, you should never hard code these secrets in the application or store them in source code."
  children = [
    aws_compliance.control.autoscaling_ec2_launch_configuration_no_sensitive_data,
    aws_compliance.control.cloudformation_stack_output_no_secrets,
    aws_compliance.control.codebuild_project_plaintext_env_variables_no_sensitive_aws_values,
    aws_compliance.control.ec2_instance_user_data_no_secrets,
    aws_compliance.control.ecs_task_definition_container_environment_no_secret
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_limit_security_groups" {
  title = "4. Limit security groups"
  description = "Security groups are a key way that you can enable network access to resources you have provisioned on AWS. Ensuring that only the required ports are open and the connection is enabled from known network ranges is a foundational approach to security."
  children = [
    aws_compliance.control.ec2_instance_no_launch_wizard_security_group,
    aws_compliance.control.vpc_default_security_group_restricts_all_traffic,
    aws_compliance.control.vpc_security_group_allows_ingress_authorized_ports,
    aws_compliance.control.vpc_security_group_allows_ingress_to_cassandra_ports,
    aws_compliance.control.vpc_security_group_allows_ingress_to_memcached_port,
    aws_compliance.control.vpc_security_group_allows_ingress_to_mongodb_ports,
    aws_compliance.control.vpc_security_group_allows_ingress_to_oracle_ports,
    aws_compliance.control.vpc_security_group_restrict_ingress_kafka_port,
    aws_compliance.control.vpc_security_group_restrict_ingress_redis_port,
    aws_compliance.control.vpc_security_group_restrict_ingress_ssh_all,
    aws_compliance.control.vpc_security_group_restrict_ingress_tcp_udp_all,
    aws_compliance.control.vpc_security_group_restricted_common_ports
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_intentional_data_policies" {
  title = "5. Intentional data policies"
  description = "Not all data is created equal, which means classifying data properly is crucial to its security. It's important to accommodate the complex tradeoffs between a strict security posture and a flexible agile environment."
  children = [
    aws_compliance.control.apigateway_rest_api_endpoint_restrict_public_access,
    aws_compliance.control.cloudtrail_bucket_not_public,
    aws_compliance.control.ebs_snapshot_not_publicly_restorable,
    aws_compliance.control.ec2_ami_restrict_public_access,
    aws_compliance.control.ec2_instance_not_publicly_accessible,
    aws_compliance.control.ecr_repository_prohibit_public_access,
    aws_compliance.control.efs_file_system_restrict_public_access,
    aws_compliance.control.eks_cluster_endpoint_restrict_public_access,
    aws_compliance.control.elb_application_classic_network_lb_prohibit_public_access,
    aws_compliance.control.emr_account_public_access_blocked,
    aws_compliance.control.kms_cmk_policy_prohibit_public_access,
    aws_compliance.control.lambda_function_restrict_public_access,
    aws_compliance.control.rds_db_instance_prohibit_public_access,
    aws_compliance.control.redshift_cluster_prohibit_public_access,
    aws_compliance.control.s3_bucket_policy_restrict_public_access,
    aws_compliance.control.s3_bucket_policy_restricts_cross_account_permission_changes,
    aws_compliance.control.s3_bucket_restrict_public_read_access,
    aws_compliance.control.s3_bucket_restrict_public_write_access,
    aws_compliance.control.s3_public_access_block_account,
    aws_compliance.control.s3_public_access_block_bucket_account,
    aws_compliance.control.sns_topic_policy_prohibit_public_access,
    aws_compliance.control.sqs_queue_policy_prohibit_public_access,
    aws_compliance.control.ssm_document_prohibit_public_access,
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_centralize_cloudtrail_logs" {
  title = "6. Centralize CloudTrail logs"
  description = "Logging and monitoring are important parts of a robust security plan. Being able to investigate unexpected changes in your environment or perform analysis to iterate on your security posture relies on having access to data. AWS recommends that you write logs, especially AWS CloudTrail, to an S3 bucket in an AWS account designated for logging (Log Archive)."
  children = [
    aws_compliance.control.cloudtrail_multi_region_trail_enabled,
    aws_compliance.control.cloudtrail_security_trail_enabled,
    aws_compliance.control.cloudtrail_trail_enabled,
    aws_compliance.control.cloudtrail_trail_insight_selectors_and_logging_enabled,
    aws_compliance.control.cloudtrail_trail_integrated_with_logs
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_validate_iam_roles" {
  title = "7. Validate IAM roles"
  description = "As you operate your AWS accounts to iterate and build capability, you may end up creating multiple IAM roles that you discover later you don't need."
  children = [
    control.iam_access_analyzer_enabled,
    aws_compliance.control.iam_access_analyzer_enabled_without_findings,
    aws_compliance.control.iam_role_cross_account_read_only_access_policy,
    aws_compliance.control.iam_role_unused_60,
    aws_perimeter.control.iam_role_trust_policy_prohibit_public_access,
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_take_action_on_findings" {
  title = "8. Take action on findings"
  description = "AWS Security Hub, Amazon GuardDuty, and AWS Identity and Access Management Access Analyzer are managed AWS services that provide you with actionable findings in your AWS accounts. They are easy to turn on and can integrate across multiple accounts. Turning them on is the first step. You also need to take action when you see findings."
  children = [
    aws_compliance.control.guardduty_enabled,
    aws_compliance.control.guardduty_no_high_severity_findings,
    aws_compliance.control.iam_access_analyzer_enabled_without_findings,
    aws_compliance.control.securityhub_enabled,
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_rotate_keys" {
  title = "9. Rotate keys"
  description = "If you need to use access keys rather than roles, you should rotate them regularly."
  children = [
    control.iam_user_one_active_key,
    aws_compliance.control.iam_user_access_key_age_90
  ]

  tags = local.account_security_common_tags
}

benchmark "account_security_dev_cycle" {
  title = "10. Be involved in the dev cycle"
  description = "Raise the security culture of your organization by being involved in the dev cycle."
  children = [
    control.manual_control
  ]

  tags = local.account_security_common_tags
}
