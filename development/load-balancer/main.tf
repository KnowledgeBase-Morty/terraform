# Load Balancer
resource "aws_alb" "md_dev_loadbalancer_uswest2" {
  name               = "md-dev-loadbalancer-uswest2"
  load_balancer_type = "application"
  security_groups    = ["${var.load_balancer_security_group_id}"]
  subnets            = var.public_subnet_ids
  # cross_zone_load_balancing = true

  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   interval            = 30
  #   target              = "HTTP:80/"
  #   # path                = "/"
  #   # protocol            = "HTTP"
  # }

  # listener {
  #   lb_port           = 80
  #   lb_protocol       = "http"
  #   instance_port     = "80"
  #   instance_protocol = "http"
  # }

  tags = {
    name = "md-dev-loadbalancer-uswest2"
  }
}

resource "aws_lb_target_group" "md_dev_loadbalancer_targetgroup_uswest2" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "md_dev_loadbalancer_listener_uswest2" {
  load_balancer_arn = aws_alb.md_dev_loadbalancer_uswest2.arn #  load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.md_dev_loadbalancer_targetgroup_uswest2.arn # target group
  }
}
