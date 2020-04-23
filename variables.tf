// Globals
variable "vpc_id" {
  description = "The id of your vpc."
}

variable "cluster_name" {
  description = "The name of the cluster that we're deploying to."
}

// Task configuration
variable "app_name" {
  description = "The name of your app. This is used in the task configuration."
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

variable "container_definition" {
  description = "A container definitions JSON file."
}

variable "desired_task_count" {
  default     = 1
  description = "The desired number of tasks for the service to keep running. Defaults to one."
}

variable "service_role_arn" {
  description = "The arn of the role to associate with your ecs service."
}

variable "service_deployment_maximum_percent" {
  default     = "200"
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Defaults to 200 percent, which should be used in 99% of cases to allow for proper green/blue."
}

variable "launch_type" {
  default     = "EC2"
  description = "The launch type for the task. We assume EC2 by default."
}

variable "volumes" {
  type        = list(any)
  default     = [{ name = "dev-null", host_path = "/dev/null" }]
  description = "A list of definitions to attach volumes to the ECS task. Amazon does not allow empty volume names once declared, so defaulting to a dummy name if this var is left unused."
}

variable "task_role_arn" {
  default     = ""
  description = "The arn of the iam role you wish to pass to the ecs task containers."
}
