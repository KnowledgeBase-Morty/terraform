resource "aws_codebuild_project" "example" {
  name          = "md-dev-pipeline-build-project"
  build_timeout = "5"
  service_role  = var.codepipeline_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  #   cache {
  #     type     = "S3"
  #     location = var.bucket_location
  #   }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0" #"aws/codebuild/standard:1.0"
    type         = "LINUX_CONTAINER"
    # image_pull_credentials_type = "CODEBUILD"

    # environment_variable {
    #   name  = "SOME_KEY1"
    #   value = "SOME_VALUE1"
    # }

    # environment_variable {
    #   name  = "SOME_KEY2"
    #   value = "SOME_VALUE2"
    #   type  = "PARAMETER_STORE"
    # }
  }

  #   logs_config {
  #     cloudwatch_logs {
  #       group_name  = "log-group"
  #       stream_name = "log-stream"
  #     }

  #     s3_logs {
  #       status   = "ENABLED"
  #       location = "${var.bucket_id}/build-log"
  #     }
  #   }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  #   source {
  #     type            = "GITHUB"
  #     location        = "https://github.com/Morty-Mortensen/mortensen-development.git"
  #     git_clone_depth = 1

  #     git_submodules_config {
  #       fetch_submodules = true
  #     }
  #   }

  # source_version = "develop"

  ## TODO: I don't think I need anything in here...
  #   vpc_config {
  #     vpc_id = aws_vpc.example.id

  #     subnets = [
  #       aws_subnet.example1.id,
  #       aws_subnet.example2.id,
  #     ]

  #     security_group_ids = [
  #       aws_security_group.example1.id,
  #       aws_security_group.example2.id,
  #     ]
  #   }

  tags = {
    Name = "md-dev-pipeline-build-project"
  }
}
