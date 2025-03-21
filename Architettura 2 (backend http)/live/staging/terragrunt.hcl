include {
	path = find_in_parent_folders()
}

terraform {
	source = "../../modules/ec2"
}

locals {
	common_tags = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

inputs = {
	ami_id = "ami-04f87c366aa353bc5" 
	instance_type = "t2.micro"
	inst_tags = merge(local.common_tags.inputs, 
		{Name = "staging-instance", 
		Environment = "staging"})

}