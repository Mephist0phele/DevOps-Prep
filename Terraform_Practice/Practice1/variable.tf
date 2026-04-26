variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the web server"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the web server will be deployed"
  default     = null
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}