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
  children = [
    aws_compliance.control.cis_v120_1_18
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_use_mfa" {
  title = "2. Use multi-factor authentication (MFA)"
  children = [
    aws_compliance.control.iam_root_user_mfa_enabled,
    aws_compliance.control.iam_user_console_access_mfa_enabled,
    aws_compliance.control.iam_user_mfa_enabled
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_no_secrets" {
  title = "3. No hard-coding secrets"
  children = [
    aws_compliance.control.cloudformation_stack_output_no_secrets,
    aws_compliance.control.ec2_instance_user_data_no_secrets,
    aws_compliance.control.ecs_task_definition_container_environment_no_secret
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_limit_security_groups" {
  title = "4. Limit security groups"
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
  children = [
    aws_compliance.benchmark.foundational_security_cloudtrail,
    aws_compliance.control.foundational_security_cloudtrail_1,
    aws_compliance.control.foundational_security_cloudtrail_5,
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_validate_iam_roles" {
  title = "7. Validate IAM roles"
  children = [
    aws_compliance.control.cis_v150_1_20,
    aws_compliance.control.iam_access_analyzer_enabled_without_findings,
    aws_perimeter.control.iam_role_trust_policy_prohibit_public_access
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_take_action_on_findings" {
  title = "8. Take action on findings"
  children = [
    aws_compliance.control.cis_v150_4_16,
    aws_compliance.control.foundational_security_guardduty_1,
    aws_compliance.control.guardduty_no_high_severity_findings,
  ]

  tags = local.aws_top_10_tags
}

benchmark "aws_top_10_security_rotate_keys" {
  title = "9. Rotate keys"
  children = [
    aws_compliance.control.cis_v120_1_12,
    aws_compliance.control.cis_v150_1_13,
    aws_compliance.control.cis_v150_1_14
  ]

  tags = local.aws_top_10_tags
}
