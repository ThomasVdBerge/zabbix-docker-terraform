output "Zabbix Endpoint" {
  value = "https://${var.aws_route53_hosted_zone_id == "false" ? aws_alb.alb.dns_name : var.domain}"
}

output "Zabbix ECR Endpoint" {
  value = "${aws_ecr_repository.repo.repository_url}"
}
