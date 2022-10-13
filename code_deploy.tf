resource "aws_codedeploy_app" "umf_prod_deployment" {
  name             = "umf-prod-deployment"
  compute_platform = "Server"
}

resource "aws_sns_topic" "umf_prod_sns_topic" {
  name = "umf_prod_sns_topic"
}

resource "aws_codedeploy_deployment_config" "umf_prod_config" {
  deployment_config_name = "CodeDeployDefault2.EC2AllAtOnce"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "umf_prod" {
  app_name              = aws_codedeploy_app.umf_prod_deployment.name
  deployment_group_name = "prod"
  service_role_arn      = data.aws_iam_role.ec2_iam_role.arn


  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "event-trigger"
    trigger_target_arn = aws_sns_topic.umf_prod_sns_topic.arn
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["umf-prod-alarm"]
    enabled = true
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.umf_prod_lb_tg.name
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = [aws_autoscaling_group.umf_prod_asg.id]
}
