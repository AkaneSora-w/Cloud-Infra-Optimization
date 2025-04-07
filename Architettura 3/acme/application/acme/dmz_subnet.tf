data "aws_internet_gateway" "ig" {
  count = local.create_dmz
  filter {
    name   = "attachment.vpc-id"
    values = [var.networking.vpc_id]
  }
}

######################################
# DMZ subnet
######################################

resource "aws_subnet" "dmz" {
  count      = local.create_dmz
  vpc_id     = var.networking.vpc_id
  cidr_block = var.networking.dmz_cidr_block

  tags = {
    Name = "${var.owner}-public-dmz"
  }
}

resource "aws_route_table" "dmz_rt" {
  count  = local.create_dmz
  vpc_id = var.networking.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.ig[0].internet_gateway_id
  }
  tags = {
    Name = "${var.owner}-public-dmz-rt"
  }
}

resource "aws_route_table_association" "dmz_rt_association" {
  count          = local.create_dmz
  subnet_id      = aws_subnet.dmz[0].id
  route_table_id = aws_route_table.dmz_rt[0].id
}


######################################
# DMZ NACL
######################################

resource "aws_network_acl" "dmz" {

  count  = local.create_dmz
  vpc_id = var.networking.vpc_id

  egress {
    protocol   = -1
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "deny"
    cidr_block = "10.101.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.owner}-dmz-nacl"
  }
}

resource "aws_network_acl_association" "dmz_nacl_association" {
  count          = local.create_dmz
  network_acl_id = aws_network_acl.dmz[0].id
  subnet_id      = try(aws_subnet.dmz[0].id, "missing dmz_cidr_block")
}