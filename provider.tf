provider "aws" {
  region  = "eu-west-2"
}

provider "aws" {
  alias  = "target"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "requester"
  region = "me-south-1"
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
