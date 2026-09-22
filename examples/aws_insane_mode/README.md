### Usage Example AWS Insane Mode

In this example, a greenfield AWS spoke is deployed with insane mode (High Performance Encryption) enabled and two gateway instances.

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
  insane_mode    = true
  instances = {
    "App1"   = {}
    "App1-2" = {}
  }
}
```
