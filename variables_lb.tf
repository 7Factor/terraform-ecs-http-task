// Load balancer configuration. Splitting this into it's own file since there's
// a lot of stuff in here.
variable "enable_loadbalancer" {
  type        = bool
  default     = true
  description = "Enables load balancing. If you set this to true, you need to set all other LB values."
}
variable "lb_public_subnets" {
  type        = list(string)
  default     = []
  description = "The list of subnet IDs to attach to the LB. Should be public."
}

variable "lb_security_policy" {
  default     = "ELBSecurityPolicy-FS-2018-06"
  description = "Security policy for the load balancer. Defaults to something interesting."
}

variable "lb_cert_arn" {
  default     = ""
  description = "Certificate ARN for securing HTTPS on our load balancer. We will automagically set up a redirect from 80."
}

variable "lb_ingress_cidr" {
  default     = "0.0.0.0/0"
  description = "CIDR to allow access to this load balancer. Allows white listing of IPs if you need that kind of thing, otherwise it just defaults to erebody."
}

variable "cluster_lb_sg_id" {
  default     = ""
  description = "The id of the ECS cluster load balancer security group."
}

variable "is_lb_internal" {
  default     = false
  description = "Switch for setting your LB to be internal. Defaults to false."
}

variable "secure_listener_enabled" {
  default     = true
  description = "Switch the secure redict from 80 to 443 on or off. On by default because this is a good idea, but you can turn it off if you have a weird edge case."
}

variable "alb_access_logs_bucket" {
  default     = ""
  description = "The bucket to log alb access logs to."
}

variable "alb_access_logs_enabled" {
  default     = false
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