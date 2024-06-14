include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "envcommon_vpc" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon_vpc.locals.sg_base_source_url}?version=5.1.2"
}

dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc/vpc"
  mock_outputs = {
    vpc_id                      = "vpc-1234 (mock)"
    private_subnets_cidr_blocks = ["10.123.123.123/24"]
  }
}

dependency "sg_ngw" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc/security-group/ngw"
  mock_outputs = {
    security_group_id = "sg-1234 (mock)"
  }
}

inputs = {
  name   = "${include.root.locals.prefix}-${basename(get_terragrunt_dir())}"
  vpc_id = dependency.vpc.outputs.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow Inboud All from private subnet"
      cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks[0]
    },
  ],
  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Allow HTTP from NGW"
      source_security_group_id = dependency.sg_ngw.outputs.security_group_id
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow HTTPS from NGW"
      source_security_group_id = dependency.sg_ngw.outputs.security_group_id
    },
  ],
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow Outbond - All"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
