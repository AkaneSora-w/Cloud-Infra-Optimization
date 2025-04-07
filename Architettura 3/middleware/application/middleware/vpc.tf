module "vpc" {
  count   = local.centralized_networking ? 0 : 1
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${local.networking_prefix}-vpc"
  cidr = var.vpc_cidr

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets = var.public_subnets

  private_subnets       = var.app_private_subnets
  private_subnet_suffix = "natted"

  database_subnets       = var.db_private_subnets
  database_subnet_suffix = "database"

  // Create one shared NAT Gateway between private_subnets

  enable_nat_gateway = local.create_dedicated_nat
  single_nat_gateway = true
  nat_gateway_tags   = { Name = "${local.networking_prefix}-nat-gtw" }
  nat_eip_tags       = { Name = "${local.networking_prefix}-nat-gtw-eip" }
  igw_tags           = { Name = "${local.networking_prefix}-igw" }

  // Database subnet group

  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  database_subnet_group_name         = local.prefix

}

moved {
  from = module.vpc
  to   = module.vpc[0]
}

// Added for connect wind3 to
resource "aws_ec2_transit_gateway_vpc_attachment" "centralized_networking" {
  count              = local.create_dedicated_nat ? 0 : 1
  subnet_ids         = module.vpc[0].private_subnets
  transit_gateway_id = var.central_transit_gateway_id
  vpc_id             = module.vpc[0].vpc_id

  tags = {
    name = "${var.owner}-central-tgw"
  }
}

resource "aws_route" "centralized" {
  for_each = local.create_dedicated_nat ? tomap({}) : tomap({
    for index , route_table_id in module.vpc[0].private_route_table_ids :
    index => route_table_id})

  route_table_id         = each.key
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.central_transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.centralized_networking]

}
