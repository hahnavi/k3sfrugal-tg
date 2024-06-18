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
    public_subnets_cidr_blocks  = ["10.231.231.0/24"]
  }
}

inputs = {
  name   = "${include.root.locals.prefix}-${basename(get_terragrunt_dir())}"
  vpc_id = dependency.vpc.outputs.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH"
      cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks[0]
    },
  ],
  egress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH to Public Subnet"
      cidr_blocks = dependency.vpc.outputs.public_subnets_cidr_blocks[0]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH to Private Subnet"
      cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks[0]
    },
  ]
}
