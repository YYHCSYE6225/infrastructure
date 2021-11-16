resource "aws_codedeploy_app" "csye6225-webapp" {
  compute_platform = "Server"
  name             = "csye6225-webapp"
}

resource "aws_codedeploy_deployment_group" "csye6225-webapp-deployment" {
  app_name               = aws_codedeploy_app.csye6225-webapp.name
  deployment_group_name  = "csye6225-webapp-deployment"
  service_role_arn       = aws_iam_role.CodeDeployServiceRole.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  autoscaling_groups = [aws_autoscaling_group.auto_scaling_group.name]
  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "csye6225-EC2"
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.alb_group.name
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

}