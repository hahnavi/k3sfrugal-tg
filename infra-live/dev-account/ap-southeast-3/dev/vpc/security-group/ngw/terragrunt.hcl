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
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id                      = "vpc-1234 (mock)"
    private_subnets_cidr_blocks = ["10.123.123.0/24"]
  }
}

inputs = {
  name   = "${include.root.locals.prefix}-${basename(get_terragrunt_dir())}"
  vpc_id = dependency.vpc.outputs.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP from Public"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS from Public"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic from private subnet"
      cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks[0]
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
