resource "aws_route53_record" "route53" {
  count = "${var.aws_route53_hosted_zone_id == "false" ? 0 : 1}"
  zone_id = "${var.aws_route53_hosted_zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${aws_alb.alb.dns_name}"
    zone_id = "${aws_alb.alb.zone_id}"
    evaluate_target_health = false
  }
}
