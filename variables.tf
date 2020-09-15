// Globals
variable "vpc_id" {
  description = "The id of your vpc."
}

variable "cluster_name" {
  description = "The name of the cluster that we're deploying to."
}

// Load balancer configuration
variable "lb_public_subnets" {
  type        = list
  description = "The list of subnet IDs to attach to the LB. Should be public."
}

variable "lb_security_policy" {
  default     = "ELBSecurityPolicy-FS-2018-06"
  description = "Security policy for the load balancer. Defaults to something interesting."
}

variable "lb_cert_arn" {
  description = "Certificate ARN for securing HTTPS on our load balancer. We will automagically set up a redirect from 80."
}

variable "lb_ingress_cidr" {
  default     = "0.0.0.0/0"
  description = "CIDR to allow access to this load balancer. Allows white listing of IPs if you need that kind of thing, otherwise it just defaults to erebody."
}

variable "cluster_lb_sg_id" {
  description = "The id of the ECS cluster load balancer security group."
}

variable "is_lb_internal" {
  default     = "false"
  description = "Switch for setting your LB to be internal. Defaults to false."
}

variable "secure_listener_enabled" {
  default     = "true"
  description = "Switch the secure redict from 80 to 443 on or off. On by default because this is a good idea, but you can turn it off if you have a weird edge case."
}

variable "alb_access_logs_bucket" {
  default     = ""
  description = "The bucket to log alb access logs to."
}

variable "alb_access_logs_enabled" {
  default     = "false"
  description = "Flag for controlling alb access logs."
}

// Health check (defaults to something sane)
variable "health_check_interval" {
  default     = 30
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
}

variable "health_check_path" {
  default     = "/"
  description = "The destination for the health check request."
}

variable "health_check_port" {
  default     = "traffic-port"
  description = "The port to use to connect with the target. Valid values are either ports 1-65536, or traffic-port. Defaults to traffic-port."
}

variable "health_check_protocol" {
  default     = "HTTP"
  description = "The protocol to use to connect with the target. Defaults to HTTP."
}

variable "health_check_timeout" {
  default     = 5
  description = "The amount of time, in seconds, during which no response means a failed health check. For Application Load Balancers, the range is 2 to 60 seconds and the default is 5 seconds. "
}

variable "health_check_threshold" {
  default     = 3
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 3."
}

variable "health_check_unhealthy_threshold" {
  default     = 3
  description = "The number of consecutive health check failures required before considering the target unhealthy ."
}

variable "health_check_matcher" {
  default     = "200"
  description = "The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (for example, '200,202') or a range of values (for example, '200-299'). "
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
  type        = list(object({ name = string, host_path = string }))
  default     = []
  description = "A list of definitions to attach volumes to the ECS task. Amazon does not allow empty volume names once declared, so defaulting to a dummy name if this var is left unused."
}

variable "task_role_arn" {
  default     = ""
  description = "The arn of the iam role you wish to pass to the ecs task containers."
}
