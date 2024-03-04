mod "aws_top_10" {
  # hub metadata
  title         = "AWS Top 10"
  description   = "The AWS Top 10 mod provides curated sets of benchmarks and controls for security, cost, operations, and more."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-top-10.svg"
  categories    = ["aws", "public cloud", "security"]

  opengraph {
    title       = "Powerpipe Mod for AWS Top 10"
    description = "The AWS Top 10 mod provides curated sets of benchmarks and controls for security, cost, operations, and more."
    image       = "/images/mods/turbot/aws-top-10-social-graphic.png"
  }

  require {
    mod "github.com/turbot/steampipe-mod-aws-compliance" {
      version = ">=0.76.0"
      args = {
        common_dimensions = var.common_dimensions
        tag_dimensions    = var.tag_dimensions
      }
    }
    mod "github.com/turbot/steampipe-mod-aws-perimeter" {
      version = ">=0.5.0"
      args = {
        common_dimensions = var.common_dimensions
        tag_dimensions    = var.tag_dimensions
      }
    }
  }
}
