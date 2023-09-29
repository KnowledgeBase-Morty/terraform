# # Auto Scaling Group - connects the loadbalancer -> ec2 launch config
# resource "aws_autoscaling_group" "md_dev_autoscaling_group_uswest2" {
#   # name             = "md-dev-asg-uswest2"
#   min_size         = 1
#   desired_capacity = 1
#   max_size         = 2

#   health_check_type = "ELB"
#   load_balancers    = ["${var.load_balancer_id}"]
#   launch_template {
#     id = var.launch_template_id
#   }
#   enabled_metrics = [
#     "GroupMinSize",
#     "GroupMaxSize",
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupTotalInstances"
#   ]
#   metrics_granularity = "1Minute"
#   vpc_zone_identifier = var.public_subnet_ids

#   # Required to redeploy without an outage.
#   lifecycle {
#     create_before_destroy = true
#   }
#   tag {
#     key                 = "Name"
#     value               = "md_dev_autoscaling_group_uswest2"
#     propagate_at_launch = true
#   }
# }

# # Auto Scaling Policy - Describes how auto-scaling should occur
# resource "aws_autoscaling_policy" "md_dev_autoscaling_policy_uswest2_up" {
#   name                   = "md_dev_autoscaling_policy_uswest2_up"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.md_dev_autoscaling_group_uswest2.name
# }

# resource "aws_cloudwatch_metric_alarm" "md_dev_cpu_alarm_uswest2_up" {
#   alarm_name          = "md_dev_cpu_alarm_uswest2_up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "70"
#   dimensions = {
#     AutoScalingGroupName = "${aws_autoscaling_group.md_dev_autoscaling_group_uswest2.name}"
#   }
#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions     = ["${aws_autoscaling_policy.md_dev_autoscaling_policy_uswest2_up.arn}"]
# }

# resource "aws_autoscaling_policy" "md_dev_autoscaling_policy_uswest2_down" {
#   name                   = "md_dev_autoscaling_policy_uswest2_down"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.md_dev_autoscaling_group_uswest2.name
# }

# resource "aws_cloudwatch_metric_alarm" "md_dev_cpu_alarm_uswest2_down" {
#   alarm_name          = "md_dev_cpu_alarm_uswest2_down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "30"
#   dimensions = {
#     AutoScalingGroupName = "${aws_autoscaling_group.md_dev_autoscaling_group_uswest2.name}"
#   }
#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions     = ["${aws_autoscaling_policy.md_dev_autoscaling_policy_uswest2_down.arn}"]
# }



resource "aws_appautoscaling_target" "md_dev_autoscaling_ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.esc_cluster_name}/${var.esc_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "md_dev_autoscaling_ecs_policy" {
  name               = "md-dev-ecs-autoscaling-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.md_dev_autoscaling_ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.md_dev_autoscaling_ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.md_dev_autoscaling_ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    # Difference between alarm threshold and the CloudWatch metric
    step_adjustment {
      metric_interval_upper_bound = 2.0
      scaling_adjustment          = -1
    }

    step_adjustment {
      metric_interval_lower_bound = 2.0
      scaling_adjustment          = 1
    }
  }
}
