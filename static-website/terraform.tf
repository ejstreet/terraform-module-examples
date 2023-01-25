terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

provider "aws" {
  alias = "global"

  region = "us-east-1"
  default_tags {
    tags = var.default_tags
  }
}