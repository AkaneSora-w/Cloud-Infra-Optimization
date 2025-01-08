include {
	path = find_in_parent_folders()
}

terraform {
	source = "../../modules/ec2"
}

inputs = {
	ami_id = "ami-0d64bb532e0502c46" //valore ami in input
	instance_type = "t2.micro"
	/*
	inst_name = "prod-instance"
	tag_enviroment = "prod"
	*/
	inst_tags = {
		Name = "prod-instance"
		Enviroment = "prod"
	}
}