# Cluster

resource "aws_ecs_cluster" "md_dev_ecs_cluster" {
  name = "md-dev-ecs-cluster"
}

# Task
resource "aws_ecs_task_definition" "md_dev_ecs_task" {
  family                   = "md-dev-ecs-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "md-dev-ecs-task",
      "image": "${var.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
  network_mode             = "awsvpc"    # add the AWS VPN network mode as this is required for Fargate
  memory                   = 512         # Specify the memory the container requires
  cpu                      = 256         # Specify the CPU the container requires
  execution_role_arn       = var.task_execution_role_arn
}

# Service
resource "aws_ecs_service" "app_service" {
  name            = "md-dev-ecs-service"                        # Name the service
  cluster         = aws_ecs_cluster.md_dev_ecs_cluster.id       # Reference the created Cluster
  task_definition = aws_ecs_task_definition.md_dev_ecs_task.arn # Reference the task that the service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Set up the number of containers to 1

  load_balancer {
    target_group_arn = var.load_balancer_target_group_arn # Reference the target group
    container_name   = aws_ecs_task_definition.md_dev_ecs_task.family
    container_port   = 80 # Specify the container port
  }

  network_configuration {
    subnets          = var.private_subnet_ids          # TODO: Might actually want the private ips
    assign_public_ip = false                           # Provide the containers with public IPs
    security_groups  = ["${var.esc_securitygroup_id}"] # Set up the security group
  }
}
