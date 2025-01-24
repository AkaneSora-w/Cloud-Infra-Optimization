###########################
### Backend with gitlab ###
###########################
remote_state {
  backend = "http"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    address = "https://gitlab.com/api/v4/projects/65932605/terraform/state/${basename(get_terragrunt_dir())}"
    lock_address = "https://gitlab.com/api/v4/projects/65932605/terraform/state/${basename(get_terragrunt_dir())}/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/65932605/terraform/state/${basename(get_terragrunt_dir())}/lock"
    # username = "yourusername"
    # password = get_env("GITLAB_ACCESS_TOKEN", "default-token")
    # lock_method = "POST"
    # unlock_method = "DELETE"
    # retry_wait_min = "5"
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
