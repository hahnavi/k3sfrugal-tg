include "root" {
  path = find_in_parent_folders()
  expose = true
}

include "envcommon_vpc" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon_vpc.locals.eice_base_source_url}/v1.0.0"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234 (mock)"]
  }
}

dependency "sg_eice-private" {
  config_path = "../security-group/eice"
  mock_outputs = {
    security_group_id = "sg-1234 (mock)"
  }
}

inputs = {
  name               = include.root.locals.prefix
  subnet_id          = dependency.vpc.outputs.private_subnets[0]
  security_group_ids = [dependency.sg_eice-private.outputs.security_group_id]
}
