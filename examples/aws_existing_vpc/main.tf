data "aws_vpc" "example" {
  id = var.vpc_id
}

data "aws_subnet" "gw1" {
  id = var.gw1_subnet_id
}

data "aws_subnet" "gw2" {
  id = var.gw2_subnet_id
}

module "spoke_aws_1" {
  source  = "terraform-aviatrix-modules/mc-spoke-group/aviatrix"
  version = "9.0.0"

  cloud            = "AWS"
  name             = "App1"
  region           = "eu-west-1"
  account          = "AWS-Account"
  transit_gw       = "avx-eu-west-1-transit"
  network_domain   = "blue"
  use_existing_vpc = true
  vpc_id           = data.aws_vpc.example.vpc_id

  instances = {
    "App1" = {
      subnet = data.aws_subnet.gw1.cidr_block
    }
    "App1-2" = {
      subnet = data.aws_subnet.gw2.cidr_block
    }
  }
}
