locals {
  envcommon_k3s-cluster = read_terragrunt_config(find_in_parent_folders("_envcommon/k3s-cluster.hcl"))
  create_spot_instance  = true
  instance_type         = "t4g.micro"
  spot_max_price        = "0.0019"
}

terraform {
  source = "${local.envcommon_k3s-cluster.locals.k3s-node_base_source_url}/server/v1.0.0"
}

dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc/vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234 (mock)"]
  }
}

dependency "sg_k3s-node" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/k3s-cluster/security-group/k3s-node"
  mock_outputs = {
    security_group_id = "sg-1234 (mock)"
  }
}

dependency "iam-role" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/k3s-cluster/iam-role"
  mock_outputs = {
    instance_profile = "instance-profile (mock)"
  }
}
