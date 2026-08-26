##################################
# Test IAM Role
##################################

resource "aws_iam_role" "codebuild_test_role" {
  name = "${var.app_name}-codebuild-test-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

}

##################################
# Test CloudWatch Logs
##################################
resource "aws_iam_role_policy" "codebuild_test_logs" {
  name = "nginx-app-codebuild-test-logs"
  role = aws_iam_role.codebuild_test_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup"
        ]

        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/terraform-nginx-test"
      },
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/terraform-nginx-test:*"
      }
    ]
  })
}

##################################
# Test S3 Artifact Access
##################################

resource "aws_iam_role_policy" "test_s3_artifacts" {
  name = "${var.app_name}-test-s3-artifacts"
  role = aws_iam_role.codebuild_test_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.codepipeline_artifact.arn}/*"

      }
    ]
  })
}