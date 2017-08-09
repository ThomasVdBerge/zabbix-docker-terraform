module "zabbix-vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"
  name = "ecs-vpc-${var.name}"
  cidr = "10.0.0.0/16"
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"]
  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"]
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_security_group" "ecs_alb" {
  name_prefix = "ecs_alb-${module.zabbix-vpc.vpc_id}-"
  #description = "Allow all inbound http(s) traffic"
  description = "Allow all inbound https traffic"
  vpc_id = "${module.zabbix-vpc.vpc_id}"

  ingress = {
    from_port = 10051
    to_port = 10051
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_instance" {
  name_prefix = "ecs_instance-${module.zabbix-vpc.vpc_id}-"
  description = "Allow http cluster traffic on ports 80"
  vpc_id = "${module.zabbix-vpc.vpc_id}"

  ingress = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.ecs_alb.id}"]
  }

  ingress = {
    from_port = 10051
    to_port = 10051
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh_access" {
  count             = "${var.ip_ssh_access == "false" ? 0 : 1}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.ip_ssh_access}"]
  security_group_id = "${aws_security_group.ecs_instance.id}"
}

resource "aws_security_group_rule" "http_access" {
  count             = "${var.aws_certificate_arn == false ? 1 : 0}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs_alb.id}"
}

resource "aws_security_group_rule" "https_access" {
  count             = "${var.aws_certificate_arn == false ? 0 : 1}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs_alb.id}"
}

resource "aws_security_group" "rds_instance" {
  name_prefix = "rds_instance-${module.zabbix-vpc.vpc_id}-"
  description = "Allow http cluster traffic on ports 3306"
  vpc_id = "${module.zabbix-vpc.vpc_id}"

  ingress = {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.ecs_instance.id}"]
  }

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
