locals {
  s3_common_tags = merge(local.top10_common_tags, {
    service = "s3"
  })
}

benchmark "s3" {
  title         = "S3 Top 10 Controls"
  description   = "Top 10 security best practices for securing data in Amazon S3."
  documentation = file("./controls/docs/s3.md")
  children = [
    control.s3_bucket_public_access_block_account,
    control.s3_bucket_restricted_accesss,
    control.s3_bucket_iam_policy_no_star_access,
    control.guardduty_s3_protection_enabled,
    control.macie_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_versioning_objectlock_enabled,
    control.s3_bucket_server_logging_enabled,
    control.s3_bucket_cross_region_replication_enabled,
    control.securityhub_with_foundational_security_standard_enabled
  ]
  tags = local.s3_common_tags
}

control "s3_bucket_public_access_block_account" {
  title         = "1 Block public S3 buckets at the organization level"
  description   = "Designate AWS accounts for public S3 use and prevent all other S3 buckets from inadvertently becoming public by enabling S3 Block Public Access. Organizations SCPs should be used to confirm that the S3 Block Public Access setting cannot be changed. `Note:` In this control, it supports to query `Block Public Access` settings for the account. The current control does not support to query Organizations SCPs details to validate."
  sql           = query.s3_bucket_public_access_block_account.sql

  tags = local.s3_common_tags
}

control "s3_bucket_restricted_accesss" {
  title         = "2 Use bucket policies to verify all access granted is restricted and specific"
  description   = "Amazon S3 bucket policy is restricted to specific AWS principals, federated users, service principals, IP addresses, or VPCs that you provide. A bucket policy that allows a wildcard identity such as Principal `*` can potentially be accessed by anyone. A bucket policy that allows a wildcard action `*` can potentially allow a user to perform any action in the bucket."
  sql           = query.s3_bucket_restricted_accesss.sql

  tags = local.s3_common_tags
}

control "s3_bucket_iam_policy_no_star_access" {
  title         = "3 Ensure that any identity-based policies don’t use wildcard actions"
  description   = "Identity policies are policies assigned to AWS Identity and Access Management (IAM) users and roles and should follow the principle of least privilege to help prevent inadvertent access or changes to resources. Establishing least privilege identity policies includes defining specific actions such as `S3:GetObject` or `S3:PutObject` instead of `S3:*`."
  sql           = query.s3_bucket_iam_policy_no_star_access.sql

  tags = local.s3_common_tags
}

control "guardduty_s3_protection_enabled" {
  title         = "4 Enable S3 protection in GuardDuty to detect suspicious activities"
  description   = "GuardDuty enables continuously monitor and profile S3 data access events (data plane operations) and S3 configuration (control plane APIs) to detect suspicious activities. Activities such as requests coming from unusual geolocations, disabling of preventative controls, and API call patterns consistent with an attempt to discover misconfigured bucket permissions. To achieve this, GuardDuty uses a combination of anomaly detection, machine learning, and continuously updated threat intelligence."
  sql           = query.guardduty_s3_protection_enabled.sql

  tags = local.s3_common_tags
}

control "macie_enabled" {
  title         = "5 Use Macie to scan for sensitive data outside of designated areas"
  description   = "Macie helps you discover and protect your sensitive data by using machine learning to automatically review and classify your data in S3. Enabling Macie organization wide is a straightforward and cost-efficient method for you to get a central, continuously updated view of your entire organization’s S3 environment and monitor your adherence to security best practices through a central console. Macie continually evaluates all buckets for encryption and access control, alerting you of buckets that are public, unencrypted, or shared or replicated outside of your organization."
  sql           = query.macie_enabled.sql

  tags = local.s3_common_tags
}

control "s3_bucket_default_encryption_enabled" {
  title         = "6 Encrypt your data in S3"
  description   = "With S3 server-side encryption, S3 encrypts your data at the object level as it writes it to disks in AWS data centers and decrypts it when you access it. S3 provides multiple options for managing which encryption key AWS uses to encrypt your S3 data. This control checks the `Server-side encryption` status of the bucket irrespective of any encryption key type used."
  sql           = query.s3_bucket_default_encryption_enabled.sql

  tags = local.s3_common_tags
}

control "s3_bucket_versioning_objectlock_enabled" {
  title         = "7 Protect data in S3 from accidental deletion using S3 Versioning and S3 Object Lock"
  description   = "Amazon S3 is designed for durability of 99.999999999 percent of objects across multiple Availability Zones, is resilient against events that impact an entire zone, and designed for 99.99 percent availability over a given year. In many cases, when it comes to strategies to back up your data in S3, it’s about protecting buckets and objects from accidental deletion, in which case S3 Versioning can be used to preserve, retrieve, and restore every version of every object stored in your buckets. S3 Versioning lets you keep multiple versions of an object in the same bucket and can help you recover objects from accidental deletion or overwrite. Keep in mind this feature has costs associated. S3 `Object Lock` is another feature that helps you mitigate data loss by storing objects using a write-once-read-many (WORM) model. By using `Object Lock`, you can prevent an object from being overwritten or deleted for a fixed time or indefinitely. `Note:` Enable Object Lock only if you need to prevent objects from being deleted to have data integrity and regulatory compliance."
  sql           = query.s3_bucket_versioning_objectlock_enabled.sql

  tags = local.s3_common_tags
}

control "s3_bucket_server_logging_enabled" {
  title         = "8 Enable logging for S3 using CloudTrail and S3 server access logging"
  description   = "Amazon S3 is integrated with CloudTrail. CloudTrail captures a subset of API calls, including calls from the S3 console and code calls to the S3 APIs. In addition, you can enable CloudTrail data events for all your buckets or for a list of specific buckets. Keep in mind that a very active S3 bucket can generate a large amount of log data and increase CloudTrail costs. If this is concern around cost then consider enabling this additional logging only for S3 buckets with critical data. Server access logging provides detailed records of the requests that are made to a bucket. Server access logs can assist you in security and access audits. This control checks `Server access logging` status of S3 buckets in the account."
  sql           = query.s3_bucket_server_logging_enabled.sql

  tags = local.s3_common_tags
}

control "s3_bucket_cross_region_replication_enabled" {
  title         = "9 Backup your data in S3"
  description   = "Although S3 stores your data across multiple geographically diverse Availability Zones by default, your compliance requirements might dictate that you store data at even greater distances. Cross-region replication (CRR) allows you to replicate data between distant AWS Regions to help satisfy these requirements. CRR enables automatic, asynchronous copying of objects across buckets in different AWS Regions. For more information on object replication, see Replicating objects. Keep in mind that this feature has costs associated, you might consider CRR in selective scenarios such as S3 buckets that store critical backup data or sensitive data."
  sql           = query.s3_bucket_cross_region_replication_enabled.sql

  tags = local.s3_common_tags
}

control "securityhub_with_foundational_security_standard_enabled" {
  title         = "10 Monitor S3 using Security Hub and CloudWatch Logs"
  description   = "Security Hub provides you with a comprehensive view of your security state in AWS and helps you check your environment against security industry standards and best practices. Security Hub collects security data from across AWS accounts, services, and supported third-party partner products and helps you analyze your security trends and identify the highest priority security issues. Security Hub standards subscription enables `AWS Foundational Security Best Practices`, a set of controls that detect when your deployed accounts and resources deviate from security best practices, and provides clear remediation steps. The control checks `AWS Foundational Security Best Practices` standard in Security Hub for the account."
  sql           = query.securityhub_with_foundational_security_standard_enabled.sql

  tags = local.s3_common_tags
}
