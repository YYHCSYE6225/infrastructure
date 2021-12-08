resource "aws_launch_configuration" "asg_launch_config" {
  name                        = "asg_launch_config"
  image_id                    = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = <<-EOF
  #cloud-boothook
  #! /bin/bash
  sudo apt-get update
  export TEST="TEST"
  export DATABASE_USERNAME=${var.db_username}
  export DATABASE_PASSWORD=${var.db_password}
  export DATABASE_HOSTNAME=${aws_db_instance.mysql_db_instance.endpoint}
  export S3_BUCKET_NAME=${var.bucket_name}
  EOF
  iam_instance_profile        = "CloudWatchAgentServerRole"
  security_groups = [
    aws_security_group.application.id
  ]
}

resource "aws_autoscaling_group" "auto_scaling_group" {
  name                 = "csye6225-autoscaling"
  max_size             = 5
  min_size             = 3
  default_cooldown     = 60
  launch_configuration = aws_launch_configuration.asg_launch_config.name
  desired_capacity     = 3
  vpc_zone_identifier  = [aws_subnet.subnet["us-east-1a"].id, aws_subnet.subnet["us-east-1b"].id, aws_subnet.subnet["us-east-1c"].id]
  tag {
    key                 = "Name"
    value               = "csye6225-EC2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up_policy"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_upperbound" {
  alarm_name          = "cpu_upperbound"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto_scaling_group.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down_policy"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_lowerbound" {
  alarm_name          = "cpu_lowerbound"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "3"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto_scaling_group.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}

resource "aws_lb" "application_load_balancer" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = [aws_subnet.subnet["us-east-1a"].id, aws_subnet.subnet["us-east-1b"].id, aws_subnet.subnet["us-east-1c"].id]
  tags = {
    Name = "csye6225-application-loadbalancer"
  }
}

resource "aws_lb_target_group" "alb_group" {
  name     = "alb-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.id
  alb_target_group_arn   = aws_lb_target_group.alb_group.arn
}


resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:254269847591:certificate/a3559e63-d4b3-49f0-8c38-a1819e9ea60e"

  default_action {
    target_group_arn = aws_lb_target_group.alb_group.arn
    type             = "forward"
  }
}


