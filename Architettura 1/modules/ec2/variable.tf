variable "ami_id" {
	description = "The AMI ID to use for the instance"
	type = string
}

variable "instance_type" {
	description = "The type of instance to create"
	type = string
	default = "t2.micro" #tipo di istanza di default
}
/*
variable "tag_environment" {
	description = "tag for the instance"
  	type = string
	default = null
}

variable "inst_name" {
	description = "name for the instance"
	type = string
}
*/
variable "shared_tags" {
	description = "tag for all incoming tags from terragrunt root"
  	type = map(string)
	default = {}
}

variable "inst_tags" {
	description = "tags for the instance"
  	type = map(string)
	default = {}
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "Public subnet CIDR values"
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "Private subnet CIDR values"
  default = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}