variable "region" {
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "app_name" {
  description = "Application Name"
  default     = "route53_autoalias"
  type        = string
}

variable "log_retention_days" {
  description = "Cloudwatch Log Retation Days"
  default     = 14
  type        = number
}
