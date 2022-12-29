output "lb_dns_name" {
  value = aws_lb.umf_prod_lb.dns_name
}

output "prod_sg" {
  value = aws_security_group.prod_sg.id
}
