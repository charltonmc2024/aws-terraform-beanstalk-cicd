##################################
# CodePipeline Role
##################################

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.app_name}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


#####################################
# CodePipeline Least-Privilege Access
#####################################

resource "aws_iam_role_policy" "codepipeline_access" {
  name = "${var.app_name}-codepipeline-access"

  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      ####################
      # S3 Artifact Bucket
      ####################

      {
        Effect = "Allow"

        Action = [
          "s3:GetBucketVersioning"
        ]

        Resource = [
          aws_s3_bucket.codepipeline_artifact.arn
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]

        Resource = [
          "${aws_s3_bucket.codepipeline_artifact.arn}/*"
        ]
      },


      ############
      # CodeBuild
      ############

      {
        Effect = "Allow"

        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]

        Resource = [
          aws_codebuild_project.test.arn,
          aws_codebuild_project.build.arn,
          aws_codebuild_project.deploy.arn
        ]
      },


      #########################
      # GitHub CodeConnections
      ########################

      {
        Effect = "Allow"

        Action = [
          "codestar-connections:UseConnection"
        ]

        Resource = aws_codestarconnections_connection.github_connection.arn
      }
    ]
  })
}