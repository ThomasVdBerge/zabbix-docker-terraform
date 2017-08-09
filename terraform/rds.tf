resource "aws_db_instance" "db" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7.11"
  instance_class          = "${var.aws_db_instance_type}"
  identifier              = "${var.name}"
  name                    = "${var.name}"
  username                = "${var.name}"
  password                = "${var.db_password}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds_private.name}"
  vpc_security_group_ids  = ["${aws_security_group.rds_instance.id}"]
  parameter_group_name    = "${aws_db_parameter_group.zabbix-rds-setting.name}"
  backup_retention_period = "${var.aws_db_backup_days}"
  backup_window           = "02:00-04:00"
  maintenance_window      = "mon:05:00-mon:07:00"
  multi_az                = "${var.aws_high_availability}"
  skip_final_snapshot     = true
  apply_immediately       = true
}

resource "aws_db_subnet_group" "rds_private" {
  name        = "rds_${var.name}_private"
  description = "Private subnets for RDS instance"
  subnet_ids  = ["${module.zabbix-vpc.public_subnets}"]
}

resource "aws_db_parameter_group" "zabbix-rds-setting" {
  name = "zabbix-rds-setting"
  family = "mysql5.7"

  parameter {
    name = "character_set_client"
    value = "utf8"
  }

  parameter {
    name = "character_set_connection"
    value = "utf8"
  }

  parameter {
    name = "character_set_database"
    value = "utf8"
  }

  parameter {
    name = "character_set_filesystem"
    value = "utf8"
  }

  parameter {
    name = "character_set_results"
    value = "utf8"
  }

  parameter {
    name = "character_set_server"
    value = "utf8"
  }

  parameter {
    name = "collation_connection"
    value = "utf8_bin"
  }

  parameter {
    name = "collation_server"
    value = "utf8_bin"
  }
}
