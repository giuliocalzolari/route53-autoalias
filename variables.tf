variable "region" {
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "rate" {
  default = "rate(4 hours)"
}

variable "app_name" {
  default = "route53_autoalias"
}
