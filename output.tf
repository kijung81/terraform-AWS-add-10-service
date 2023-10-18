output "web1_public_dns" {
  value = aws_instance.web1.public_dns
}

output "web2_public_dns" {
  value = aws_instance.web2.public_dns
}

output "alb_public_dns" {
  value = aws_lb.alb.dns_name
}