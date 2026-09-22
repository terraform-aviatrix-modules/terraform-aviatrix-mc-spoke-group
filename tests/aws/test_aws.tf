terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
  }
}

provider "aviatrix" {}

module "single_instance" {
  source = "../.."

  cloud     = "aws"
  name      = "spoke-single-aws"
  region    = "eu-central-1"
  cidr      = "10.1.101.0/24"
  account   = "AWS"
  attached  = false
  instances = { for i in range(1) : "spoke-single-aws-${i + 1}" => {} }
}

module "multi_instance" {
  source = "../.."

  cloud     = "aws"
  name      = "spoke-multi-aws"
  region    = "eu-central-1"
  cidr      = "10.1.102.0/24"
  account   = "AWS"
  attached  = false
  instances = { for i in range(3) : "spoke-multi-aws-${i + 1}" => {} }
}

module "explicit_instances" {
  source = "../.."

  cloud    = "aws"
  name     = "spoke-explicit-aws"
  region   = "eu-central-1"
  cidr     = "10.1.103.0/24"
  account  = "AWS"
  attached = false

  instances = {
    "spoke-explicit-aws-primary"   = {}
    "spoke-explicit-aws-secondary" = {}
  }
}

resource "test_assertions" "cloud_type_single" {
  component = "cloud_type_single"

  equal "cloud_type" {
    description = "Cloud type is AWS."
    got         = module.single_instance.spoke_group.cloud_type
    want        = 1
  }
}

resource "test_assertions" "cloud_type_multi" {
  component = "cloud_type_multi"

  equal "cloud_type" {
    description = "Cloud type is AWS."
    got         = module.multi_instance.spoke_group.cloud_type
    want        = 1
  }
}

resource "test_assertions" "instance_count_multi" {
  component = "instance_count_multi"

  equal "instance_count" {
    description = "Three instances created."
    got         = length(module.multi_instance.spoke_instances)
    want        = 3
  }
}

resource "test_assertions" "instance_count_explicit" {
  component = "instance_count_explicit"

  equal "instance_count" {
    description = "Two explicit instances created."
    got         = length(module.explicit_instances.spoke_instances)
    want        = 2
  }
}
