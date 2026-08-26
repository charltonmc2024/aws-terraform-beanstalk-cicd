##################################
# Deploy IAM Role
##################################

resource "aws_iam_role" "codebuild_deploy_role" {
  name = "${var.app_name}-codebuild-deploy-role"

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
# Deploy CloudWatch Logs
##################################
resource "aws_iam_role_policy" "codebuild_deploy_logs" {
  name = "nginx-app-codebuild-deploy-logs"
  role = aws_iam_role.codebuild_deploy_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup"
        ]

        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/terraform-nginx-deploy"
      },
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/terraform-nginx-deploy:*"
      }
    ]
  })
}

############################################
# Elastic Beanstalk CloudWatch Logs Access
############################################

resource "aws_iam_role_policy" "deploy_elasticbeanstalk_logs" {
  name = "${var.app_name}-deploy-elasticbeanstalk-logs"
  role = aws_iam_role.codebuild_deploy_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy"
        ]

        Resource = [
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/elasticbeanstalk/${var.app_name}-production-env/*",
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/elasticbeanstalk/${var.app_name}-production-env"
        ]
      }
    ]
  })
}

##################################
# Deploy S3 Artifact Access
##################################

resource "aws_iam_role_policy" "deploy_s3_artifacts" {
  name = "${var.app_name}-deploy-s3-artifacts"
  role = aws_iam_role.codebuild_deploy_role.id

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

############################################
# Deploy Elastic Beanstalk Deployment
############################################
resource "aws_iam_role_policy" "deploy_elasticbeanstalk" {
  name = "${var.app_name}-deploy-elasticbeanstalk"
  role = aws_iam_role.codebuild_deploy_role.id

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

############################################
# Deploy CloudFormation Access
############################################

resource "aws_iam_role_policy" "deploy_cloudformation" {
  name = "${var.app_name}-deploy-cloudformation"
  role = aws_iam_role.codebuild_deploy_role.id

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