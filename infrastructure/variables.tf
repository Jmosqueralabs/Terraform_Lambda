variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "serverless-app"
}

variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Entorno (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "lambda_memory_size" {
  description = "Memoria para Lambda en MB"
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout para Lambda en segundos"
  type        = number
  default     = 10
}
