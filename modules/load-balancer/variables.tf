variable "region" {
  description = "AWS region"
  type        = string
}

variable "alb_name" {
  description = "The name of ALB"
  type = string
}

variable "target_group_name" {
  description = "The name of Target Group"
  type = string
}

variable "target_type" {
  description = "The target type"
  type = string
}

variable "target_group_port" {
  description = "The port of target group"
  type = number
}

variable "vpc_id" {
  description = "The ID of VPC"
  type = string
}

variable "alb_security_group_ids" {
  description = "List of security group ids"
  type = list(string)
}

variable "subnet_ids" {
  description = "List of subnet ids"
  type = list(string)
}
