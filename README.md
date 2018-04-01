Zabbix (Docker) on AWS ECS with Terraform
======================

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
        - [Configuration](#configuration)
        - [Starting Up](#starting-up)
- [License](#license)
- [Links](#links)

## General
### What is this?
This repository contains an easy to setup working zabbix HA cluster which runs on AWS ECS. The blogpost about this repository can be found [here](https://thomasvdberge.github.io/tutorial/2018/03/20/setting-up-zabbix-on-aws-with-terraform.html)
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
#### Configuration
The following configuration settings can be set in the file `variables.tfvars`. See `variables.tfvars.example` as example.

* [`aws_region`]: String(optional): [AWS Region](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) you want to deploy this in. (default: `eu-west-1`)
* [`aws_profile`]: String(optional) [AWS Profile](http://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html). (default: `default`)
* [`aws_instance_type`]: String(optional) [AWS Instance type](https://aws.amazon.com/ec2/instance-types/) you want this application to run on. (default: `t2.nano`)
* [`aws_db_instance_type`]: String(optional) [AWS RDS Instance type](https://aws.amazon.com/rds/pricing/) you want this application to run on. (default: `db.t2.micro`)
* [`aws_db_backup_days`]: String(optional)Amount (days) how long database backups should be stored. 0 to disable (default: 7)
* [`aws_ami`]: String(optional) Amazon AMI to use (default: `ECS Optimized`)
* [`aws_certificate_arn`]: String(optional) Amazon Certificate Manager is not in terraform. Place the ARN here. If default, zabbix will run on HTTP instead of HTTPS. (default: `false`)
* [`aws_route53_hosted_zone_id`]: String(optional) The AWS Route53 hosted zone id you want the subdomain to be created on. If false, load balancer is your endpoint. (default: `false`, example: `ZE1U20IED0CW7`)
* [`aws_high_availability`]: String(optional) Wheter or not this cluster should be considered high available. Setting this to true means multiple AZ deployment (And an increase in costs!) (default: `false`)
* [`name`]: String(optional) Name for this application (default: `Zabbix`)
* [`db_password`]: String(required) Password for the RDS database. Choose something strong (default: `changeme`)
* [`ip_ssh_access`]: String(optional) Set to false to disable ssh access (recommended). CIDR block (add /32) that has SSH access into the instance. Can be your IP or a bastion host. (default: `false`, example `192.168.0.1/32`)
* [`public_key`]: String(optional) The public key that has access to ssh into the zabbix instance. (default: `false`, example `ssh-rsa ....`)
* [`domain`]: String(optional) The domainname you want to run zabbix on. Only works if `aws_route53_hosted_zone_id` is also set! (default: `false`, example `zabbix.example.com`)

#### Starting Up
Once you got all the tools installed we can start launching our zabbix infrastructure.
1. Go inside the terraform folder and run `terraform plan -var-file=variables.tfvars`. This will give you an overview of what will be created.
2. Run `terraform apply -var-file=variables.tfvars` to start creating the Amazon AWS recources.
3. When everything is successful, You'll see output that will look like this: 
```
Outputs:

Zabbix ECR Endpoint = 435551404480.dkr.ecr.eu-west-1.amazonaws.com/zabbix
Zabbix Endpoint = https://zabbix-1844418752.eu-west-1.elb.amazonaws.com
```
4. AWS Setup is running. Now we need to deploy the docker image. Go inside the docker folder and execute `aws ecr get-login --no-include-email --region eu-west-1`

5. The previous command will return an output that starts with `docker login -u AWS -p Xeg.....`. Copy that entire output and execute it. 

6. Execute `docker build -t zabbix .` to start building the docker image

7. Execute `docker tag test:latest <Zabbix ECR Endpoint>:latest` Replace <Zabbix ECR Endpoint> with the Zabbix ECR Endpoint received in step 3

8. As a last step we need to push the docker image to our newly created repository. Execute `docker push <Zabbix ECR Endpoint>:latest` Replace <Zabbix ECR Endpoint> with the Zabbix ECR Endpoint received in step 3

9. That's it! in a moment your zabbix cluster will come online on <Zabbix Endpoint> (See step 3).

If there are any issues, please do let me know!

## License
The Zabbix (Docker) on AWS Terraform repository is licensed under the terms of the GPL Open Source license and is available for free.

## Links

* [Zabbix XXL](https://github.com/monitoringartist/zabbix-xxl)
* [Stefan Radu Blog](https://rstefan.blogspot.be/2013/07/amazon-cloudwatch-query-tool-for-zabbix.html)

