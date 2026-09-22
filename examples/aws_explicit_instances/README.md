### Usage Example AWS Explicit Instances

In this example, a greenfield AWS spoke is deployed with an explicit instance map providing per-instance overrides for gateway size and tags.

```hcl
module "spoke_aws_1" {
  source  = "terraform-aviatrix-modules/mc-spoke-group/aviatrix"
  version = "9.0.0"

  cloud          = "AWS"
  name           = "App1"
  cidr           = "10.1.0.0/20"
  region         = "eu-west-1"
  account        = "AWS-Account"
  transit_gw     = "avx-eu-west-1-transit"
  network_domain = "blue"

  tags = {
    environment = "production"
  }

  instances = {
    "App1" = {
      gw_size = "c5.xlarge"
      tags = {
        role = "primary"
      }
    }
    "App1-2" = {
      gw_size = "c5.xlarge"
      tags = {
        role = "secondary"
      }
    }
  }
}
```
