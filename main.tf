provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "terraform"
      Repository  = "terraform-aws-bootstrap"
      Environment = var.environment
    }
  }
}
