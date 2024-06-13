include "root" {
  path = find_in_parent_folders()
  expose = true
}

include "envcommon_k3s-cluster" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/k3s-cluster.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon_k3s-cluster.locals.k3s-node_base_source_url}/iam-role/v1.0.0"
}

inputs = {
  name = "${include.root.locals.prefix}-k3s-node"
  project_name = include.root.locals.project_name
  env = include.root.locals.env
}
