provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Env    = "dev"
      System = "nextjs"
    }
  }
}

terraform {
  required_version = ">= 1.3.8"
  required_providers {
     aws = "4.67.0"
  }
  backend "s3" {
    profile = "terraform"
    region  = "ap-northeast-1"
    bucket  = "657885203613-tfstate"
    key     = "oidc/dev"
    encrypt = true
  }
}
