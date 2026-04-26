variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the instance"
  default     = null
}

variable "project_name" {
  type        = string
  description = "Project name for tagging"
  default     = "terraform-project"
}

variable "monitoring" {
  type        = bool
  description = "Enable detailed monitoring"
  default     = false
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
  default     = []
}
