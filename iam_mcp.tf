resource "aws_iam_user" "aws_mcp" {
  name = "aws-mcp-server"
  path = "/bootstrap/"
}

resource "aws_iam_access_key" "aws_mcp" {
  user = aws_iam_user.aws_mcp.name
}

resource "aws_iam_user_policy_attachment" "aws_mcp_read_only" {
  user       = aws_iam_user.aws_mcp.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy" "aws_mcp_sts" {
  name = "aws-mcp-sts-caller-identity"
  user = aws_iam_user.aws_mcp.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity",
        ]
        Resource = "*"
      },
    ]
  })
}
