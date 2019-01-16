# ECS Task via Terraform

This module will allow you to deploy an ECS Task and an ECS Service. This is intended to be run as part of your app deployment
pipeline. It works well with [Concourse.](https://concourse-ci.org) It is assumed you already have a solution for deploying an 
ECS Cluster. If not, check out [ours.](https://github.com/7Factor/terraform-ecs-cluster)

## Prerequisites

First, you need a decent understanding of how to use Terraform. [Hit the docs](https://www.terraform.io/intro/index.html) for that.
Then, you should familiarize yourself with ECS [concepts](https://aws.amazon.com/ecs/getting-started/), especially if you've
never worked with a clustering solution before. Once you're good, import this module and  pass the appropriate variables. 
Then, plan your run and deploy.

## Example Usage

```hcl-terraform
module "terraform-ecs-task" {
  source                = "git::https://github.com/7Factor/terraform-ecs-task.git"
  vpc_id                = "${data.aws_vpc.primary_vpc.id}"
  alb_subnets           = "${data.aws_subnet_ids.subnet_ids.ids}"
  lb_security_group_id  = "${data.aws_security_group.primary_sg.id}"
  app_name              = "${var.app_name}"
  app_port              = "${var.app_port}"
  cpu                   = "256"
  memory                = "256"
  desired_task_count    = "2"
  service_role_arn      = "${var.service_role_arn}"
  service_name          = "Angular Starter Service"
  container_definitions = "${data.template_file.container_definitions.rendered}"
}
```
