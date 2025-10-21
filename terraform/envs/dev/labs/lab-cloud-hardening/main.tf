provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source           = "../../../../modules/networking"
  vpc_cidr         = "10.0.0.0/22"
  public_subnets   = ["10.0.0.0/24"]
  private_subnets  = ["10.0.1.0/24"]
  isolated_subnets = ["10.0.2.0/24"]

  project     = "breachbeach"
  environment = "dev"
  lab_id      = "lab001"
}
