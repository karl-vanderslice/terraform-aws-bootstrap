resource "random_pet" "ops_bucket" {
  length    = 2
  separator = "-"
}

resource "aws_s3_bucket" "ops" {
  bucket = "ops-${random_pet.ops_bucket.id}"
}

resource "aws_s3_bucket_versioning" "ops" {
  bucket = aws_s3_bucket.ops.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ops" {
  bucket = aws_s3_bucket.ops.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "ops" {
  bucket                  = aws_s3_bucket.ops.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "ops_bucket" {
  name = "ops-bucket-access"
  path = "/bootstrap/"
}

resource "aws_iam_access_key" "ops_bucket" {
  user = aws_iam_user.ops_bucket.name
}

resource "aws_iam_user_policy" "ops_bucket" {
  name = "ops-bucket-access"
  user = aws_iam_user.ops_bucket.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
        ]
        Resource = [
          aws_s3_bucket.ops.arn,
          "${aws_s3_bucket.ops.arn}/*",
        ]
      },
    ]
  })
}
