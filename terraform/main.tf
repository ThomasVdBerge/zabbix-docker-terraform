terraform {
  required_version = ">= 0.9.11"
}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}
