# resource "aws_elb" "umf_prod_lb" {
#   name            = "umf-prod-elb"

#   security_groups = [
#     aws_security_group.umf_prod_lb_http.id
#   ]
#   subnets         = [
#     aws_subnet.umf_prod_public_subnet_eu_west_2a.id,
#     aws_subnet.umf_prod_public_subnet_eu_west_2b.id
#   ]

#   cross_zone_load_balancing   = true

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     interval            = 30
#     target              = "HTTP:80/"
#   }

#   listener {
#     lb_port           = 80
#     lb_protocol       = "http"
#     instance_port     = "80"
#     instance_protocol = "http"
#   }

# }

resource "aws_lb" "umf_prod_lb" {
  name               = "umf-prod-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.umf_prod_lb_http.id]
  subnets = module.vpc.public_subnets
}

resource "aws_lb_target_group" "umf_prod_lb_tg" {
  name     = "umf-prod-asg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/healthcheck"
    healthy_threshold = 6
    unhealthy_threshold = 2
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_lb_listener" "umf_prod_http_lb_listener" {
  load_balancer_arn = aws_lb.umf_prod_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.umf_prod_lb_tg.arn
  }
}

resource "aws_alb_listener" "umf_prod_https_lb_listeners" {
  depends_on          = [aws_acm_certificate.prod_lb_cert]
  load_balancer_arn   = aws_lb.umf_prod_lb.arn
  port                = 443
  protocol            = "HTTPS"
  certificate_arn     = aws_acm_certificate.prod_lb_cert.arn

  default_action {
    target_group_arn  = aws_lb_target_group.umf_prod_lb_tg.arn
    type              = "forward"
  }
}

resource "aws_autoscaling_attachment" "umf_prod_auto_a" {
  autoscaling_group_name = aws_autoscaling_group.umf_prod_asg.id
  lb_target_group_arn    = aws_lb_target_group.umf_prod_lb_tg.arn
}
