terraform {
  required_version = ">=0.10.7"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.51"
}
