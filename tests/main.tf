provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = ">= 0.11.14"
}


module "this" {
  source  = "giuliocalzolari/route53-autocname/aws"
  version = "1.0.0"
}

