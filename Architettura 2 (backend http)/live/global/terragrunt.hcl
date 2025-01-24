include "root" {
	path = find_in_parent_folders()
}

terraform {
	source = "../../modules/global"
}

# dependency "dev" {
# 	config_path = "../dev"
# 	enabled = true //default is true
# }

# dependency "prod" {
# 	config_path = "../prod"
# }

# dependency "staging" {
# 	config_path = "../staging"
# }

inputs = {
	# ec2_instances = {
	# 	"dev" = {
	# 		public_dns = dependency.dev.outputs.public_dns
	# 		work_env = "dev"
	# 	},
	# 	"prod" = {
	# 		public_dns = dependency.prod.outputs.public_dns
	# 		work_env = "prod"
	# 	},
	# 	"staging" = {
	# 		public_dns = dependency.staging.outputs.public_dns
	# 		work_env = "staging"
	# 	}
	# }
}

# locals {
# #   environments = ["dev", "prod", "staging"]
# 	env_config = yamldecode(file("${get_terragrunt_dir()}/environments.yaml"))
# }

# generate "dependencies" {
#   path      = "${get_terragrunt_dir()}/generated_dependencies.hcl"
#   if_exists = "overwrite"
#   contents  = join("\n", [
#     for env in local.env_config.environments :
#     <<EOF
#     dependency "${env.name}" {
#       config_path = "${env.config_path}"
#     }
#     EOF
#   ])
# }

# include "generated_dependencies" {
# 	path = "${get_terragrunt_dir()}/generated_dependencies.hcl"
# }

# include "generated_inputs" {
# 	path = "${get_terragrunt_dir()}/generated_inputs.hcl"
# }

# inputs = {
#   ec2_instances = {
#     for env in local.env_config.environments : env.name => {
#       public_dns = dependency[env.name].outputs.public_dns
#       work_env   = env.name
#     }
#   }
# }