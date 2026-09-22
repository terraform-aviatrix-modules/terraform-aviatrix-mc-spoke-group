module "spoke_gcp_1" {
  source  = "terraform-aviatrix-modules/mc-spoke-group/aviatrix"
  version = "9.0.0"

  cloud      = "GCP"
  name       = "spoke-gcp-1"
  cidr       = "10.1.0.0/24"
  region     = "us-east1"
  account    = "GCP-Account"
  transit_gw = "avx-us-east1-transit"
  instances = {
    "spoke-gcp-1"   = {}
    "spoke-gcp-1-2" = {}
  }
}
