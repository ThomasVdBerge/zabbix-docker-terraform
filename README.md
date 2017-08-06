Zabbix (Docker) on AWS Terraform
======================

This repository contains the code neccesary to run zabbix in a docker container on Amazon AWS.

## Table of content

- [General](#general)
    - [What?](#what-is-this)
    - [AWS Stack](#aws-stack)
- [License](#license)
- [Links](#links)

## General
### What is this?
This repository contains an easy to setup working zabbix cluster which runs on docker containers on AWS.
### AWS Stack
The following things are created when applying the terraform configuration:
- IAM
- EC2
- ECS
- RDS
- Route53

Below is a visual representation about what will be created:
![AWS Stack](https://github.com/ThomasVdBerge/zabbix-docker-terraform/blob/master/images/stack.png)

## License

The Zabbix (Docker) on AWS Terraform repository is licensed under the terms of the GPL Open Source license and is available for free.

## Links

* [Zabbix XXL](https://github.com/monitoringartist/zabbix-xxl)

