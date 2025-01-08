remote_state {
	backend = "s3"
	generate = {
		path = "backend.tf"
		if_exists = "overwrite_terragrunt"
	}
	
	config = {
		bucket = "prova-bucket2"
		key = "local/${path_relative_to_include()}/terraform.tfstate"
		region = "eu-west-1"
	}
}

generate "provider" {
	path = "./provider.tf"
	if_exists = "overwrite"
	contents = <<EOF
provider "aws" {
	region = "eu-west-1"
}

provider "aws" {
	region = "us-east-1"
	alias = "virginia"
}
	EOF
}

inputs = {
    shared_tags = {Project = "Angelo's project"}
}
