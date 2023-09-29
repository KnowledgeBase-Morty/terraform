
# Elastic Container Service Repository - This is where docker images will be pushed to
resource "aws_ecr_repository" "md_dev_ecr" {
  name = "md-dev-ecr"
}

# Process for pushing a docker image to the ECR docker repository

# 1. (In directory that contains the Dockerfile) aws ecr get-login-password --region REGION | docker login \
##--username AWS --password-stdin ID.dkr.ecr.REGION.amazonaws.com 

# 2. docker build -t app-repo .

# 3. docker tag app-repo:latest ID.dkr.REGION.amazonaws.com/app-repo:latest 

# 4. docker push ID.dkr.REGION.amazonaws.com/app-repo:latest

# TODO: This allows tmortensen & root to be able to push/pull
# A role will need to be added so that a service like CodeDeploy (or CodeBuild) can push/pull
# resource "aws_iam_policy" "md_dev_ecr_policy" {
#   name = "md-dev-ecr-policy"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "AllowPushPull",
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::131012006950:root"
#       },
#       "Action": [
#         "ecr:BatchCheckLayerAvailability",
#         "ecr:BatchGetImage",
#         "ecr:CompleteLayerUpload",
#         "ecr:GetDownloadUrlForLayer",
#         "ecr:InitiateLayerUpload",
#         "ecr:PutImage",
#         "ecr:UploadLayerPart"
#       ]
#     }
#   ]
# }
# POLICY
# }

# resource "aws_ecr_repository_policy" "md_ecr_repository_policy" {
#   repository = aws_ecr_repository.md_dev_ecr.name
#   policy     = aws_iam_policy.md_dev_ecr_policy.policy
# }
