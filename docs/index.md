# terraform-aws-bootstrap

## Purpose

Bootstrap Terraform for the AWS account. This repo establishes the foundational
AWS configuration: provider setup, account-level tagging, and the IAM and S3
primitives that all other Terraform repos depend on.

## What this repo manages

- AWS provider and region defaults
- Default tagging policy applied to all resources
- Account-level IAM foundation (roles, policies) — to be added
- Shared S3 buckets for tooling state — to be added

## State backend

Terraform Cloud, workspace `terraform-aws-bootstrap`, org `karl-vanderslice-org`.

## Next steps

1. Authenticate AWS CLI: `aws sso login` or configure `AWS_PROFILE`
2. Run `just init` to initialize the workspace
3. Run `just plan` to confirm zero-drift baseline
4. Add IAM foundation resources and re-plan
