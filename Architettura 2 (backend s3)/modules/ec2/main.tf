terraform {
  required_providers {
  
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }
  }
  required_version = ">= 1.2.0"
}

resource "random_string" "random" {
  length           = 6
  special          = false
}

resource "aws_vpc" "prova_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.prova_vpc.id
  count = length(var.public_subnet_cidrs)
  cidr_block = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.prova_vpc.id
  count = length(var.private_subnet_cidrs)
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "prova_gateway" {
  vpc_id = aws_vpc.prova_vpc.id
}

resource "aws_route_table" "prova_route_table" {
  vpc_id = aws_vpc.prova_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prova_gateway.id
  }
}

resource "aws_route_table_association" "prova_route_table_asso" {
  route_table_id = aws_route_table.prova_route_table.id
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg"
  description = "Security group per traffico in entrata sulla porta 443"
  vpc_id = aws_vpc.prova_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ] //traffico uscita verso tutti gli ip
  }
}

//definizione/creazione del ruolo IAM
resource "aws_iam_role" "ec2_role" {
  name = "ec2ssm_TestRole-${random_string.random.result}"
  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    EOF
}

//crea un instance profile per assegnare il ruolo all'istanza EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2SSMTestInstanceProfile${random_string.random.result}"
  role = aws_iam_role.ec2_role.name
}

//collega una policy esistente al ruolo
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "prova_instance" {
  ami           = var.ami_id  //va specificato in input
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet[1].id
  associate_public_ip_address = true
  
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  security_groups = [ aws_security_group.ec2_sg.id ]
  
  user_data = file("${path.module}/add-ssh-web-app.yaml")

  tags = merge (
    var.shared_tags, 
      var.inst_tags
    /*{
      Name = var.inst_name
      Environment = var.tag_environment
    }*/
  )
}
