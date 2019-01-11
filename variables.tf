// networking config
variable "region" {
  default     = "us-east-1"
  description = "The region of your infrastructure. Defaults to us-east-1."
}

variable "vpc_id" {
  description = "The id of your vpc."
}

variable "alb_subnets" {
  type        = "list"
  description = "The list of subnet IDs to attach to the LB."
}

variable "lb_security_group_id" {
  description = "The id of the sg to associate with you lb."
}

// ecs task config
variable "app_name" {
  description = "The name of your app"
}

variable "alb_port" {
  default     = 80
  description = "The port you want to open on the ALB. Defaults to 80."
}

variable "app_port" {
  description = "The port you want you open on your instances. We make no assumptions here."
}

variable "cpu" {
  default     = 256
  description = "The number of cpu units used by the task."
}

variable "memory" {
  default     = 256
  description = "The amount (in MiB) of memory used by the task."
}

variable "container_definitions" {
  description = "A container definitions template file"
}

variable "desired_task_count" {
  default     = 2
  description = "The desired number of tasks for the service to keep running. Defaults to two."
}

variable "service_role_arn" {
  description = "The arn of the role to associate with your ecs service."
}

variable "service_name" {
  description = "Will apply your service name to tags on relevant resources."
}
