# ASG Module Variables

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = ""
}

variable "min_size" {
  description = "Minimum size of ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size of ASG"
  type        = number
  default     = 6
}

variable "desired_capacity" {
  description = "Desired capacity of ASG"
  type        = number
  default     = 2
}

variable "db_endpoint" {
  description = "RDS database endpoint"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "userdb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = ""
  sensitive   = true
}
