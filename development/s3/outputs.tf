# Code Pipeline
output "codepipeline_bucket_arn" {
  value = aws_s3_bucket.codepipeline_bucket.arn
}

output "codepipeline_bucket_location" {
  value = aws_s3_bucket.codepipeline_bucket.bucket
}

output "codepipeline_bucket_id" {
  value = aws_s3_bucket.codepipeline_bucket.id
}

# Code Build
output "codebuild_bucket_arn" {
  value = aws_s3_bucket.codebuild_bucket.arn
}

output "codebuild_bucket_location" {
  value = aws_s3_bucket.codebuild_bucket.bucket
}

output "codebuild_bucket_id" {
  value = aws_s3_bucket.codebuild_bucket.id
}
