# Elastic Beanstalk

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

resource "aws_elastic_beanstalk_application" "default" {
  name = var.name
}
