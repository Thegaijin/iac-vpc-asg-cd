resource "aws_launch_configuration" "umf_prod_lc" {
  name_prefix                 = "umf-prod-"
  image_id                    = data.aws_ami.ubuntu.id # Ubuntu 20.04-amd64-server-20220914, SSD Volume Type
  instance_type               = "t3.micro"
  key_name                    = "umf-prod"
  security_groups             = [aws_security_group.prod_sg.id]
  iam_instance_profile        = data.aws_iam_role.ec2_iam_role.name
  # associate_public_ip_address = true

  user_data = data.cloudinit_config.user_data.rendered
  # user_data = file("user-data.sh")
  # user_data = <<-EOF
  # #!/bin/bash -ex

  # sudo apt-get update
  # sudo apt-get install -y nginx
  # echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
  # sudo systemctl enable nginx
  # sudo systemctl start nginx

  # EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "umf_prod_asg" {
  name = "${aws_launch_configuration.umf_prod_lc.name}-asg"

  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  # health_check_type       = "ELB"
  # load_balancers          = [
  #   aws_lb.umf_prod_lb.id
  # ]

  launch_configuration = aws_launch_configuration.umf_prod_lc.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = [aws_subnet.umf_prod_public_subnet_eu_west_2a, aws_subnet.umf_prod_public_subnet_eu_west_2b]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Enviroment"
    value                 = "prod"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "umf_prod_scale_down"
  autoscaling_group_name = aws_autoscaling_group.umf_prod_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for UMF Prod ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "umf_prod_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.umf_prod_asg.name
  }
}
