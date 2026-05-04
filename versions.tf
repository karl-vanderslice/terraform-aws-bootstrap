terraform {
  required_version = ">= 1.5.0"

  cloud {
    hostname     = "app.terraform.io"
    organization = "karl-vanderslice-org"

    workspaces {
      name = "terraform-aws-bootstrap"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.44"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0, < 4.0"
    }
  }
}
