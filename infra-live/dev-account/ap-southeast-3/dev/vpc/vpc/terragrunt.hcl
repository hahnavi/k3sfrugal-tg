include "root" {
  path = find_in_parent_folders()
  expose = true
}

include "envcommon_vpc" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon_vpc.locals.vpc_base_source_url}?version=5.8.1"
}

inputs = {
  name = include.root.locals.prefix
  cidr = "10.0.0.0/16"

  azs                           = ["${include.root.locals.aws_region}a"]
  public_subnets                = ["10.0.0.0/24"]
  private_subnets               = ["10.0.1.0/24"]
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
}
