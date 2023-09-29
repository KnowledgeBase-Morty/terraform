# Cloud Naming Convention: [prefix]-[project]-[env]-[resource]-[location]-[description]-[suffix]
# Example: md-dev-eb-uswest2 (mortensen-development, devuction, elastic beanstalk, us-west-2)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

module "vpc" {
  source             = "./vpc"
  cidr_block         = var.vpc_cidr_block
  environment_prefix = var.environment_prefix
}

module "subnet" {
  source                    = "./subnet"
  vpc_id                    = module.vpc.vpc_id
  public_cidr_blocks        = ["10.0.1.0/24", "10.0.2.0/24"]
  public_availbility_zones  = ["us-west-2a", "us-west-2b"]
  private_cidr_blocks       = ["10.0.3.0/24", "10.0.4.0/24"]
  private_availbility_zones = ["us-west-2a", "us-west-2b"]
}

module "internet_gateway" {
  source = "./internet-gateway"
  vpc_id = module.vpc.vpc_id
}

module "elastic_ip" {
  source     = "./elastic-ip"
  depends_on = [module.internet_gateway]
}

module "nat_gateway" {
  source           = "./nat-gateway"
  elastic_ip_id    = module.elastic_ip.elastic_ip_id
  public_subnet_id = module.subnet.public_subnet_ids[0]
}

module "routing" {
  source              = "./routing"
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  public_subnet_ids   = module.subnet.public_subnet_ids
  private_subnet_ids  = module.subnet.private_subnet_ids
}

module "security_group" {
  source             = "./security-group"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.subnet.private_subnet_ids
}

# module "rds" {
#   source                = "./rds"
#   rds_subnet_group_name = module.security_group.rds_subnet_group_name
#   rds_security_group_id = module.security_group.rds_security_group_id
# }

module "iam" {
  source = "./iam"
}

# module "key_pair" {
#   source               = "./key-pair"
#   public_key_file_path = var.md_eb_keypair
# }

# module "launch_template" {
#   source                          = "./launch-template"
#   iam_profile_name                = module.iam.profile_name
#   key_pair_name                   = module.key_pair.key_name
#   load_balancer_security_group_id = module.security_group.load_balancer_security_group_id
# }

module "load_balancer" {
  source                          = "./load-balancer"
  vpc_id                          = module.vpc.vpc_id
  load_balancer_security_group_id = module.security_group.load_balancer_security_group_id
  public_subnet_ids               = module.subnet.public_subnet_ids
}

module "elastic_container_repository" {
  source = "./ecr"
}

module "iam_ecs_task" {
  source = "./iam-ecs-task"
}

module "security_group_ecs" {
  source                         = "./security-group-ecs"
  vpc_id                         = module.vpc.vpc_id
  load_balancer_securitygroup_id = module.security_group.load_balancer_security_group_id
}

module "elastic_container_service" {
  source                         = "./ecs"
  repository_url                 = module.elastic_container_repository.repository_url
  task_execution_role_arn        = module.iam_ecs_task.task_execution_role_arn
  load_balancer_target_group_arn = module.load_balancer.load_balancer_target_group_arn
  private_subnet_ids             = module.subnet.private_subnet_ids
  esc_securitygroup_id           = module.security_group_ecs.ecs_security_group_id
}

module "app_autoscaleing" {
  source           = "./app-autoscaling"
  esc_cluster_name = module.elastic_container_service.esc_cluster_name
  esc_service_name = module.elastic_container_service.esc_service_name
}


# Pipeline

module "s3" {
  source = "./s3"
}

module "iam_codebuild" {
  source                  = "./iam-codebuild"
  bucket_arn              = module.s3.codebuild_bucket_arn
  codepipeline_bucket_arn = module.s3.codepipeline_bucket_arn
}

module "code_build" {
  source                = "./code-build"
  bucket_location       = module.s3.codebuild_bucket_location
  bucket_id             = module.s3.codebuild_bucket_id
  codepipeline_role_arn = module.iam_codebuild.codebuild_role_arn
}

module "codestar_connection" {
  source = "./codestar-connection"
}

module "iam_codepipeline" {
  source                = "./iam-codepipline"
  bucket_arn            = module.s3.codepipeline_bucket_arn
  github_connection_arn = module.codestar_connection.github_connection_arn
}

module "code_pipeline" {
  source                = "./code-pipeline"
  bucket_location       = module.s3.codepipeline_bucket_location
  codepipeline_role_arn = module.iam_codepipeline.codepipline_role_arn
  github_connection_arn = module.codestar_connection.github_connection_arn
}
