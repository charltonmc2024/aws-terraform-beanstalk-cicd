##################################
# CodeBuild IAM Role
##################################

resource "aws_iam_role" "codebuild_build_role" {
  name = "${var.app_name}-codebuild-build-role"

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
# CodeBuild CloudWatch Logs
##################################

resource "aws_iam_role_policy" "codebuild_logs" {
  name = "${var.app_name}-codebuild-logs"
  role = aws_iam_role.codebuild_build_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy"
        ]

        Resource = [
          "arn:aws:logs:${var.aws_region}:*:log-group:/aws/codebuild/*",
          "arn:aws:logs:${var.aws_region}:*:log-group:/aws/elasticbeanstalk/*",
          "arn:aws:logs:${var.aws_region}:*:log-group:/aws/elasticbeanstalk/*:*"
        ]
      }
    ]
  })
}



##################################
# CodeBuild S3 Artifact Access
##################################

resource "aws_iam_role_policy" "codebuild_s3_artifacts" {
  name = "${var.app_name}-codebuild-s3-artifacts"
  role = aws_iam_role.codebuild_build_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.codepipeline_artifact.arn}/*"
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetBucketVersioning",
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.codepipeline_artifact.arn
      }
    ]
  })
}


##################################
# CodeBuild ECR Access
##################################

resource "aws_iam_role_policy" "codebuild_ecr" {
  name = "${var.app_name}-codebuild-ecr"
  role = aws_iam_role.codebuild_build_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = aws_ecr_repository.nginx.arn
      },

      {
        Effect = "Allow"

        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]

        Resource = aws_ecr_repository.nginx.arn
      }
    ]
  })
}