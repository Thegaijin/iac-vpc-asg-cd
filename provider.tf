provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "umf-vpc-terraform"
    key    = "prod/terraform.tfstate"
    region = "eu-west-2"
  }
}
