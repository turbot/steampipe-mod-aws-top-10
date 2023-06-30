variable "common_dimensions" {
  type        = list(string)
  description = "A list of common dimensions to add to each control."
  # Define which common dimensions should be added to each control.
  # - account_id
  # - connection_name (_ctx ->> 'connection_name')
  # - region
  default = ["account_id", "region"]
}

variable "tag_dimensions" {
  type        = list(string)
  description = "A list of tags to add as dimensions to each control."
  # A list of tag names to include as dimensions for resources that support
  # tags (e.g. "Owner", "Environment"). Default to empty since tag names are
  # a personal choice - for commonly used tag names see
  # https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html#tag-categories
  default = []
}

locals {

  # Local internal variable to build the SQL select clause for common
  # dimensions using a table name qualifier if required. Do not edit directly.
  common_dimensions_qualifier_sql = <<-EOQ
  %{~if contains(var.common_dimensions, "connection_name")}, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{endif~}
  %{~if contains(var.common_dimensions, "region")}, __QUALIFIER__region%{endif~}
  %{~if contains(var.common_dimensions, "account_id")}, __QUALIFIER__account_id%{endif~}
  EOQ

  common_dimensions_qualifier_global_sql = <<-EOQ
  %{~if contains(var.common_dimensions, "connection_name")}, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{endif~}
  %{~if contains(var.common_dimensions, "account_id")}, __QUALIFIER__account_id%{endif~}
  EOQ

  # Local internal variable to build the SQL select clause for tag
  # dimensions. Do not edit directly.
  tag_dimensions_qualifier_sql = <<-EOQ
  %{~for dim in var.tag_dimensions},  __QUALIFIER__tags ->> '${dim}' as "${replace(dim, "\"", "\"\"")}"%{endfor~}
  EOQ

}

locals {

  # Local internal variable with the full SQL select clause for common
  # dimensions. Do not edit directly.
  common_dimensions_sql        = replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "")
  common_dimensions_global_sql = replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "")
  tag_dimensions_sql           = replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "")

}


mod "aws_security_top_10" {
  # hub metadata
  title         = " AWS Security Top 10"
  description   = "Check the top security items recommended on the AWS Security blog."
  #color         = "#FF9900"
  #documentation = file("./docs/index.md")
  #icon          = "/images/mods/turbot/aws-well-architected.svg"
  categories    = ["aws", "security"]

  opengraph {
    title       = "Steampipe Mod for AWS Security Top 10"
    description = "Run controls across all of your AWS accounts and regions to check the top 10 security items recommended on the AWS Security blog."
    image       = "/images/mods/turbot/aws-well-architected-social-graphic.png"
  }

  require {
    plugin "aws" {
      min_version = "0.101.0"
    }
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = ">=0.66.0"
      args = {
        common_dimensions = var.common_dimensions
        tag_dimensions    = var.tag_dimensions
      }
    }
    mod "github.com/turbot/steampipe-mod-aws-perimeter" {
      version = "*"
    }
  }
}

