resource "aws_ecs_cluster" "cluster_zabbix" {
  name = "${var.name}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data")}"
  vars {
    cluster_name = "${var.name}"
  }
}

resource "aws_launch_configuration" "launch_configuration_zabbix_ecs" {
  count                = "${var.public_key == "false" ? 1 : 1}"
  name_prefix          = "ecs-${var.name}-"
  instance_type        = "${var.aws_instance_type}"
  image_id             = "${lookup(var.aws_ami, var.aws_region)}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  security_groups      = [
    "${aws_security_group.ecs_instance.id}"
  ]
  user_data            = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "launch_configuration_zabbix_ecs_key" {
  count                = "${var.public_key == "false" ? 0 : 1}"
  name_prefix          = "ecs-${var.name}-"
  instance_type        = "${var.aws_instance_type}"
  image_id             = "${lookup(var.aws_ami, var.aws_region)}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  security_groups      = [
    "${aws_security_group.ecs_instance.id}"
  ]
  user_data            = "${data.template_file.user_data.rendered}"

  key_name             = "${aws_key_pair.key.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group_zabbix_ecs" {
  count                = "${var.public_key == "false" ? 1 : 0}"
  name                 = "ecs-cluster-${var.name}"
  vpc_zone_identifier  = [
    "${module.zabbix-vpc.public_subnets}"
  ]
  min_size             = 1
  max_size             = 2
  desired_capacity     = "${var.aws_high_availability == "false" ? 1 : 2}"
  launch_configuration = "${aws_launch_configuration.launch_configuration_zabbix_ecs.name}"
  health_check_type    = "EC2"
  target_group_arns    = [
    "${aws_alb_target_group.target_group.arn}",
  ]
  tag {
    key                 = "Name"
    value               = "ecs-${var.name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group_zabbix_ecs_key" {
  count                = "${var.public_key == "false" ? 0 : 1}"
  name                 = "ecs-cluster-${var.name}"
  vpc_zone_identifier  = [
    "${module.zabbix-vpc.public_subnets}"
  ]
  min_size             = 1
  max_size             = 2
  desired_capacity     = "${var.aws_high_availability == "false" ? 1 : 2}"
  launch_configuration = "${aws_launch_configuration.launch_configuration_zabbix_ecs_key.name}"
  health_check_type    = "EC2"
  target_group_arns    = [
    "${aws_alb_target_group.target_group.arn}",
  ]
  tag {
    key                 = "Name"
    value               = "ecs-${var.name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ecs_container_definition" "container_definition" {
  task_definition = "${aws_ecs_task_definition.task.id}"
  container_name = "${var.name}"
}

resource "aws_ecs_service" "service" {
  name = "${var.name}"
  cluster = "${aws_ecs_cluster.cluster_zabbix.id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count = 1
}

resource "aws_ecs_task_definition" "task" {
  family = "${var.name}"
  container_definitions = <<DEFINITION
[
    {
		"name": "${var.name}",
		"image": "${aws_ecr_repository.repo.repository_url}:latest",
		"hostname": "${var.name}",
		"cpu": ${lookup(var.aws_ecs_task_cpu, var.aws_instance_type)},
		"memory": ${lookup(var.aws_ecs_task_memory, var.aws_instance_type)},
		"essential": true,
		"portMappings": [
			{
				"containerPort": 80,
				"hostPort": 80
			},
			{
				"containerPort": 10051,
				"hostPort": 10051
			}
		],
		"environment" : [
			{
				"name" : "ZS_DBHost",
				"value" : "${aws_db_instance.db.address}"
			},
			{
				"name" : "ZS_DBUser",
				"value" : "${var.name}"
			},
			{
				"name" : "ZS_DBPassword",
				"value" : "${var.db_password}"
			}
		]
	}
]
DEFINITION
}
