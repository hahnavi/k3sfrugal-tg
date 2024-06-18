include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon_vpc" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon_vpc.locals.ngw_base_source_url}/v1.0.0"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    public_subnets          = ["subnet-1234 (mock)"]
    private_route_table_ids = ["rtb-1234 (mock)"]
  }
}

dependency "sg_ngw" {
  config_path = "../security-group/${basename(get_terragrunt_dir())}"
  mock_outputs = {
    security_group_id = "sg-1234 (mock)"
  }
}

inputs = {
  name                   = "${include.root.locals.prefix}-${basename(get_terragrunt_dir())}"
  create_spot_instance   = true
  subnet_id              = dependency.vpc.outputs.public_subnets[0]
  security_groups        = [dependency.sg_ngw.outputs.security_group_id]
  private_route_table_id = dependency.vpc.outputs.private_route_table_ids[0]
}
