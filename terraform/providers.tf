provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.1.7"
}
