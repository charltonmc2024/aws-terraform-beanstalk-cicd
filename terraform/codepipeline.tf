
##################################
# CodePipeline
##################################

resource "aws_codepipeline" "terraform_pipeline" {

  name = "${var.app_name}-CodePipeline"

  role_arn = aws_iam_role.codepipeline_role.arn


  artifact_store {

    location = aws_s3_bucket.codepipeline_artifact.bucket

    type = "S3"

  }


  ##################################
  # Source Stage
  ##################################

  stage {

    name = "Source"


    action {

      name = "GitHub_Source"

      category = "Source"

      owner = "AWS"

      provider = "CodeStarSourceConnection"

      version = "1"


      output_artifacts = [
        "source_output"
      ]


      configuration = {

        ConnectionArn = coalesce(var.codestar_connection_arn, aws_codestarconnections_connection.github_connection.arn)

        FullRepositoryId = var.github_repository

        BranchName = var.github_branch

      }

    }

  }


  ##################################
  # Test Stage
  ##################################

  stage {

    name = "Test"


    action {

      name = "Terraform_Test"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts  = ["source_output"]
      output_artifacts = ["test_output"]

      configuration = {

        ProjectName = aws_codebuild_project.test.name

      }

    }

  }


  ##################################
  # Build Stage
  ##################################

  stage {

    name = "Build"


    action {

      name = "Terraform_Build"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = ["test_output"]


      output_artifacts = ["build_output"]

      configuration = {

        ProjectName = aws_codebuild_project.build.name

      }

    }

  }


  ##################################
  # Deploy Stage
  ##################################

  stage {

    name = "Deploy"


    action {

      name = "ElasticBeanstalk_Deploy"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      version = "1"


      input_artifacts = ["build_output"]

      configuration = {

        ProjectName = aws_codebuild_project.deploy.name

      }

    }

  }

}
