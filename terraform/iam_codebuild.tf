##################################
# CodeBuild IAM Role
##################################

resource "aws_iam_role" "codebuild_role" {
  name = "${var.app_name}-codebuild-role"

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


############################################
# CodeBuild CloudFormation Access
############################################

resource "aws_iam_role_policy" "codebuild_cloudformation" {
  name = "${var.app_name}-codebuild-cloudformation"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "cloudformation:GetTemplate",
          "cloudformation:DescribeStackResource",
          "cloudformation:DescribeStackResources",
          "cloudformation:DescribeStacks",
          "cloudformation:DescribeStackEvents",
          "cloudformation:UpdateStack",
          "cloudformation:CancelUpdateStack"
        ]

        Resource = "*"
      }
    ]
  })
}



############################################
# CodeBuild Elastic Beanstalk Deployment
############################################

resource "aws_iam_role_policy" "codebuild_elasticbeanstalk" {
  name = "${var.app_name}-codebuild-elasticbeanstalk"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "elasticbeanstalk:CreateApplicationVersion",
          "elasticbeanstalk:UpdateEnvironment",
          "elasticbeanstalk:DescribeEnvironments",
          "elasticbeanstalk:DescribeEvents",
          "elasticbeanstalk:DescribeApplicationVersions"
        ]

        Resource = "*"
      },

      # EC2 read access required by Elastic Beanstalk
      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeAvailabilityZones"
        ]

        Resource = "*"
      },
      # EC2 launch template access required by Elastic Beanstalk
      {
        Effect = "Allow"

        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:ModifyLaunchTemplate",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteLaunchTemplateVersions"
        ]

        Resource = "*"
      },



      # Elastic Beanstalk S3 bucket access
      {
        Effect = "Allow"

        Action = [
          "s3:CreateBucket",
          "s3:GetBucket*",
          "s3:ListBucket",
          "s3:PutBucketPolicy"
        ]

        Resource = "arn:aws:s3:::elasticbeanstalk-*"
      },

      # Auto Scaling access required by Elastic Beanstalk during rolling deployments
      {
        Effect = "Allow"

        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:SuspendProcesses",
          "autoscaling:ResumeProcesses"
        ]

        Resource = "*"
      },

      # Elastic Load Balancing read access required by Elastic Beanstalk
      {
        Effect = "Allow"

        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth"
        ]

        Resource = "*"
      },

      # Elastic Beanstalk S3 object access
      {
        Effect = "Allow"

        Action = [
          "s3:Get*",
          "s3:Put*",
          "s3:Delete*"
        ]

        Resource = "arn:aws:s3:::elasticbeanstalk-*/*"
      }
    ]
  })
}



##################################
# CodeBuild CloudWatch Logs
##################################

resource "aws_iam_role_policy" "codebuild_logs" {
  name = "${var.app_name}-codebuild-logs"
  role = aws_iam_role.codebuild_role.id

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
  role = aws_iam_role.codebuild_role.id

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
  role = aws_iam_role.codebuild_role.id

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