# # TODO: Needs to be created in the dashboard (https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html))
# resource "aws_codestarconnections_connection" "github_connection" {
#   name          = "mortensen-development-connection"
#   provider_type = "GitHub"
# }

# Creates bucket (TODO: Might need to later)
# resource "aws_s3_bucket" "codepipeline_bucket" {
#   bucket = "md-dev-codepipeline"
# }

# Sets bucket's permission level - 
# resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
#   bucket = aws_s3_bucket.codepipeline_bucket.id
#   acl    = "private"
# }

# IAM role for Code Pipeline
# resource "aws_iam_role" "codepipeline_role" {
#   name = "md-dev-codepipline-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codepipeline.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# # Policy attached to the Code Pipeline role
# resource "aws_iam_role_policy" "codepipeline_policy" {
#   name = "md-dev-codepipeline-policy"
#   role = aws_iam_role.codepipeline_role.id

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect":"Allow",
#       "Action": [
#         "s3:GetObject",
#         "s3:GetObjectVersion",
#         "s3:GetBucketVersioning",
#         "s3:PutObjectAcl",
#         "s3:PutObject"
#       ],
#       "Resource": [
#         "${aws_s3_bucket.codepipeline_bucket.arn}",
#         "${aws_s3_bucket.codepipeline_bucket.arn}/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codestar-connections:UseConnection"
#       ],
#       "Resource": "${aws_codestarconnections_connection.github_connection.arn}"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codebuild:BatchGetBuilds",
#         "codebuild:StartBuild"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# Encryption for bucket? Not quite sure...
# resource "aws_kms_key" "s3_key" {
#   tags = {
#     Name = "md-dev-s3-key"
#   }
# }

# Code Pipeline
resource "aws_codepipeline" "codepipeline" {
  name     = "md-dev-pipeline"
  role_arn = var.codepipeline_role_arn

  # After deploy?
  artifact_store {
    location = var.bucket_location
    type     = "S3"

    # encryption_key {
    #   id   = aws_kms_key.s3_key.arn
    #   type = "KMS"
    # }
  }

  # Pull code (First time it goes into a PENDING state - Go here to fix: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html)
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source-code-output"]

      configuration = {
        ConnectionArn    = var.github_connection_arn
        FullRepositoryId = "Morty-Mortensen/mortensen-development"
        BranchName       = "develop"
        DetectChanges    = true
      }
    }
  }

  # Build application
  stage {
    name = "md-dev-pipeline-build"

    action {
      name             = "md-dev-pipeline-build-action"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source-code-output"]
      output_artifacts = ["build-code-output"]
      version          = "1"

      configuration = {
        ProjectName = "md-dev-pipeline-build-project"
      }
    }
  }

  # Deploy application (How to deploy to Auto Scaling Group with Launch Template?)
  stage {
    name = "md-dev-pipeline-deploy"

    action {
      name            = "md-dev-pipeline-deploy-action"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build-code-output"]
      version         = "1"

      configuration = {
        ActionMode     = "REPLACE_ON_FAILURE"
        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName      = "MyStack"
        TemplatePath   = "build_output::sam-templated.yaml"
      }
    }
  }
}
