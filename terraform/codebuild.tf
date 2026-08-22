##################################
# CodeBuild Test Project
##################################

resource "aws_codebuild_project" "test" {
  name        = "${var.app_name}-test"
  description = "Test NGINX Docker application and Terraform"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "APP_NAME"
      value = var.app_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/../buildspec-test.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/terraform-nginx-test"
      stream_name = "test"
    }
  }
}


##################################
# CodeBuild Build Project
##################################

resource "aws_codebuild_project" "build" {
  name        = "${var.app_name}-build"
  description = "Build NGINX Docker deployment artifact"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "APP_NAME"
      value = var.app_name
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = aws_ecr_repository.nginx.repository_url
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/../buildspec-build.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/terraform-nginx-build"
      stream_name = "build"
    }
  }
}


##################################
# CodeBuild Deploy Project
##################################

resource "aws_codebuild_project" "deploy" {
  name        = "${var.app_name}-deploy"
  description = "Deploy NGINX Docker application to Elastic Beanstalk"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "APP_NAME"
      value = var.app_name
    }

    environment_variable {
      name  = "CODEPIPELINE_ARTIFACT_BUCKET"
      value = aws_s3_bucket.codepipeline_artifact.bucket
    }

    environment_variable {
      name  = "EB_APPLICATION_NAME"
      value = aws_elastic_beanstalk_application.nginx.name
    }

    environment_variable {
      name  = "EB_ENVIRONMENT_NAME"
      value = aws_elastic_beanstalk_environment.nginx_env.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/../buildspec-deploy.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/terraform-nginx-deploy"
      stream_name = "deploy"
    }
  }
}