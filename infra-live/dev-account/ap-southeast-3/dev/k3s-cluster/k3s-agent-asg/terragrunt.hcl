include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon_k3s-cluster" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/k3s-cluster.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon_k3s-cluster.locals.k3s-node_base_source_url}/agent-asg/v1.0.0"
}

dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc/vpc"
  mock_outputs = {
    private_subnets = ["subnet-1234 (mock)"]
  }
}

dependency "ngw" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc/ngw"
  mock_outputs = {
    private_ip = "10.123.123.123"
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

inputs = {
  name                         = "${include.root.locals.prefix}-${basename(get_terragrunt_dir())}"
  create_spot_instance         = true
  instance_type                = "t4g.micro"
  spot_max_price               = "0.0019"
  vpc_zone_identifier          = dependency.vpc.outputs.private_subnets
  vpc_security_group_ids       = [dependency.sg_k3s-node.outputs.security_group_id]
  iam_instance_profile         = dependency.iam-role.outputs.instance_profile
  k3s_token_ssm_parameter_name = "/${include.root.locals.project_name}/${include.root.locals.env}/k3s/token"
  k3s_server_url               = "https://${dependency.ngw.outputs.private_ip}:16443"
}
