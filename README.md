# terraform-aws-bootstrap

Terraform module that bootstraps the AWS account foundation — IAM, S3, and
account-level guardrails. State is stored in Terraform Cloud.

## What this manages

- AWS provider configuration
- Account-level defaults and tagging policy
- Foundation IAM roles and policies (to be added)
- S3 buckets for shared tooling (to be added)

## Prerequisites

- Terraform >= 1.5.0
- Terraform Cloud account (`karl-vanderslice-org` organization)
- AWS credentials with sufficient IAM privileges
- Nix (for hermetic dev shell)

## Usage

```bash
# Enter dev shell
nix develop

# Authenticate with Terraform Cloud
terraform login

# Initialize
just init

# Plan
just plan

# Apply
just apply
```

## AWS authentication

Configure credentials before running any Terraform command:

```bash
# Via environment variables
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...   # if using assumed role / SSO

# Or configure a named profile in ~/.aws/credentials
export AWS_PROFILE=bootstrap
```

Or use AWS SSO:

```bash
aws sso login --profile bootstrap
export AWS_PROFILE=bootstrap
```

## Justfile helpers

| Target           | Description                              |
| ---------------- | ---------------------------------------- |
| `just fmt`       | Format Terraform files                   |
| `just init`      | Initialize providers and modules         |
| `just validate`  | Validate Terraform configuration locally |
| `just plan`      | Show planned changes                     |
| `just apply`     | Apply changes to AWS                     |
| `just checkov`   | Run Checkov security scan                |
| `just lint`      | Run `nix flake check`                    |
| `just pre-commit`| Run all pre-commit hooks                 |

## State backend

Terraform Cloud, workspace `terraform-aws-bootstrap` under org
`karl-vanderslice-org`. Remote execution is disabled — state only.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
