### Usage Example AWS Greenfield Spoke

In this example, a greenfield AWS spoke is deployed with two gateway instances using the instances map.

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
  instances = {
    "App1"   = {}
    "App1-2" = {}
  }
}
```
