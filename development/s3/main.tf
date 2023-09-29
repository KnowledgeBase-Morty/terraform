resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "md-dev-codepipeline"
}

resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "md-dev-codebuild"
}
