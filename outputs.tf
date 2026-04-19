output "ops_bucket_name" {
  description = "Name of the ops S3 bucket."
  value       = aws_s3_bucket.ops.bucket
}

output "ops_bucket_arn" {
  description = "ARN of the ops S3 bucket."
  value       = aws_s3_bucket.ops.arn
}

output "ops_bucket_access_key_id" {
  description = "Access key ID for the ops bucket IAM user."
  value       = aws_iam_access_key.ops_bucket.id
}

output "ops_bucket_secret_access_key" {
  description = "Secret access key for the ops bucket IAM user."
  value       = aws_iam_access_key.ops_bucket.secret
  sensitive   = true
}

output "vault_iam_access_key_id" {
  description = "Access key ID for the Vault AWS secrets engine IAM user."
  value       = aws_iam_access_key.vault.id
}

output "vault_iam_secret_access_key" {
  description = "Secret access key for the Vault AWS secrets engine IAM user."
  value       = aws_iam_access_key.vault.secret
  sensitive   = true
}

output "aws_mcp_access_key_id" {
  description = "Access key ID for the AWS API MCP IAM user."
  value       = aws_iam_access_key.aws_mcp.id
}

output "aws_mcp_secret_access_key" {
  description = "Secret access key for the AWS API MCP IAM user."
  value       = aws_iam_access_key.aws_mcp.secret
  sensitive   = true
}

output "aws_region" {
  description = "AWS region configured for bootstrap resources."
  value       = var.aws_region
}
# Add outputs here as resources are provisioned.
