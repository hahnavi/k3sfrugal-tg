include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "k3s-server_common" {
  path   = find_in_parent_folders("k3s-server_common.hcl")
  expose = true
}

dependencies {
  paths = ["../k3s-server-1"]
}

inputs = {
  name                   = "${include.root.locals.prefix}-${basename(get_terragrunt_dir())}"
  project_name           = include.root.locals.project_name
  env                    = include.root.locals.env
  create_spot_instance   = include.k3s-server_common.locals.create_spot_instance
  instance_type          = include.k3s-server_common.locals.instance_type
  private_ip             = "10.0.1.12"
  spot_max_price         = include.k3s-server_common.locals.spot_max_price
  subnet_id              = dependency.vpc.outputs.private_subnets[0]
  vpc_security_group_ids = [dependency.sg_k3s-node.outputs.security_group_id]
  iam_instance_profile   = dependency.iam-role.outputs.instance_profile
}
