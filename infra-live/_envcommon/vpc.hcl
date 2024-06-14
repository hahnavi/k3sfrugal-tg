locals {
  vpc_base_source_url  = "tfr:///terraform-aws-modules/vpc/aws"
  sg_base_source_url   = "tfr:///terraform-aws-modules/security-group/aws"
  ngw_base_source_url  = "${dirname(find_in_parent_folders())}/../infra-modules/ngw"
  eice_base_source_url = "${dirname(find_in_parent_folders())}/../infra-modules/eice"
}
