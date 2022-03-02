variable "region" {
  default     = "us-east-1"
  description = "AWS region"
  type        = string
}

variable "kubernetes_version" {
  type        = string
  default     = "1.21"
  description = "version of kubernetes"
}

variable "frontend_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "frontend instance type"
}

variable "backend_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "backend instance type"
}

variable "frontend_desired_capacity" {
  type        = string
  default     = 1
  description = "desired capacity for frontend"
}

variable "backend_desired_capacity" {
  type        = string
  default     = 1
  description = "desired capacity for backend"
}

variable "cluster_name" {
  type    = string
  default = "primary"
}