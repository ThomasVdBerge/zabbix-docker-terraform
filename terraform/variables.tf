variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "AWS profile to use."
  default     = "default"
}

variable "aws_instance_type" {
  description = "AWS Instance type you want this application to run on"
  default     = "t2.nano"
}

variable "aws_db_instance_type" {
  description = "AWS RDS Instance type you want this application to run on"
  default     = "db.t2.micro"
}

variable "aws_db_backup_days" {
  description = "Amount (days) how long database backups should be stored"
  default     = 7
}

variable "aws_ami" {
  description = "amzn-ami-2017.03.f-amazon-ecs-optimized. See http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"
  type = "map"
  default = {
    eu-west-1 = "ami-8fcc32f6"
  }
}

variable "aws_certificate_arn" {
  description = "Amazon Certificate Manager is not in terraform. Place the ARN here. If left false, zabbix will run on HTTP instead of HTTPS"
  default     = "false"
}

variable "aws_route53_hosted_zone_id" {
  description = "The hosted zone id you want the subdomain to be created on. If false, load balancer is your endpoint."
  default     = "false"
}

variable "aws_ecs_task_cpu" {
  description = ""
  type = "map"
  default = {
    t2.nano = 1024
    t2.micro = 1024
    t2.small = 1024
  }
}

variable "aws_ecs_task_memory" {
  description = ""
  type = "map"
  default = {
    t2.nano = 489
    t2.micro = 993
    t2.small = 2001
  }
}

variable "aws_high_availability" {
  description = "Wheter or not this cluster should be considered high available. Setting this to true means multiple AZ deployment (And an increase in costs!)"
  default     = "false"
}

variable "name" {
  description = "Name for this application"
  default     = "zabbix"
}

variable "db_password" {
  description = "password for the database"
  default     = "changeme"
}

variable "ip_ssh_access" {
  description = "Set to false to disable ssh access (recommended). CIDR block (add /32) that has SSH access into the instance. Can be your IP or a bastion host."
  default     = "false"
}

variable "public_key" {
  description = "The public key that has access to ssh into the zabbix instance."
  default     = "false"
}

variable "domain" {
  description = "The domainname zabbix has (for example: zabbix.example.com. Then zabbix will be create on zabbix.example.com)"
  default     = "false"
}
