resource "aws_key_pair" "key" {
  count      = "${var.public_key == "false" ? 0 : 1}"
  key_name   = "${var.name}-key"
  public_key = "${var.public_key}"
}

resource "aws_iam_role" "ecs_elb" {
  name = "ecs-elb-${var.name}"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_for_elb" {
  role = "${aws_iam_role.ecs_elb.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role" "ecs" {
  name = "ecs-${var.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_for_ec2" {
  role = "${aws_iam_role.ecs.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "ecs-${var.name}-cloudwatch-policy"
  role = "${aws_iam_role.ecs.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-profile-${var.name}"
  role = "${aws_iam_role.ecs.name}"
}
