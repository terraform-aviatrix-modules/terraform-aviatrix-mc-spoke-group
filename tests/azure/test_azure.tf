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

  cloud     = "azure"
  name      = "spoke-single-azure"
  region    = "West Europe"
  cidr      = "10.1.101.0/24"
  account   = "Azure"
  attached  = false
  instances = { for i in range(1) : "spoke-single-azure-${i + 1}" => {} }
}

module "multi_instance" {
  source = "../.."

  cloud     = "azure"
  name      = "spoke-multi-azure"
  region    = "West Europe"
  cidr      = "10.1.102.0/24"
  account   = "Azure"
  attached  = false
  instances = { for i in range(2) : "spoke-multi-azure-${i + 1}" => {} }
}

resource "test_assertions" "cloud_type_single" {
  component = "cloud_type_single"

  equal "cloud_type" {
    description = "Cloud type is Azure."
    got         = module.single_instance.spoke_group.cloud_type
    want        = 8
  }
}

resource "test_assertions" "cloud_type_multi" {
  component = "cloud_type_multi"

  equal "cloud_type" {
    description = "Cloud type is Azure."
    got         = module.multi_instance.spoke_group.cloud_type
    want        = 8
  }
}
