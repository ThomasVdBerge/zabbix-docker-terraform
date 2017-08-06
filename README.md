Zabbix (Docker) on AWS Terraform
======================

This repository contains the code neccesary to run zabbix in a docker container on Amazon AWS.

## Table of content

- [General](#general)
    - [What?](#what-is-this)
    - [AWS Stack](#aws-stack)
- [Installation](#installation)
    - [Tools](#tools)
        - [AWS Cli](#aws-cli)
        - [Docker](#docker)
        - [Terraform](#docker)
    - [Application](#application)
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

## Installation

### Tools
#### AWS Cli
The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts.

Please see the manual on [Amazon AWS](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) on how to install aws-cli.

#### Docker
Docker is the world’s leading software container platform. Developers use Docker to eliminate “works on my machine” problems when collaborating on code with co-workers. Operators use Docker to run and manage apps side-by-side in isolated containers to get better compute density. Enterprises use Docker to build agile software delivery pipelines to ship new features faster, more securely and with confidence for both Linux and Windows Server apps.

Please see the manual on [Docker](https://docs.docker.com/get-started/#setup) on how to install docker and on how to run an example hello-world application.

#### Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

Please see the manual on [Terraform](https://www.terraform.io/intro/getting-started/install.html) on how to install terraform.

### Application
Work in progress. Not completed yet
## License

The Zabbix (Docker) on AWS Terraform repository is licensed under the terms of the GPL Open Source license and is available for free.

## Links

* [Zabbix XXL](https://github.com/monitoringartist/zabbix-xxl)
* [Stefan Radu Blog](https://rstefan.blogspot.be/2013/07/amazon-cloudwatch-query-tool-for-zabbix.html)

