variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources into."
}

variable "environment" {
  type        = string
  default     = "bootstrap"
  description = "Environment label applied via default_tags."
}
