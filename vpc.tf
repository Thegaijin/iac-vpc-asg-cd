resource "aws_vpc" "umf_prod_vpc" {
  provider             = aws.london
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name  = "UMF prod VPC"
    key   = "Enviroment"
    value   = "prod"
  }
}

resource "aws_subnet" "umf_prod_public_subnet_eu_west_2a" {
  vpc_id              = aws_vpc.umf_prod_vpc.id
  cidr_block          = "10.0.0.0/24"
  availability_zone   = "eu-west-2a"


  tags = {
    Name = "UMF prod public Subnet us-west-2a"
    key  = "Enviroment"
    value  = "prod"
  }
}

resource "aws_subnet" "umf_prod_public_subnet_eu_west_2b" {
  vpc_id             = aws_vpc.umf_prod_vpc.id
  cidr_block         = "10.0.1.0/24"
  availability_zone  = "eu-west-2b"

  tags = {
    Name = "UMF prod public Subnet us-west-2b"
    key  = "Enviroment"
    value  = "prod"
  }
}

# resource "aws_subnet" "umf_private_subnet_me_south_1a" {
#   vpc_id             = var.default_vpc_id
#   cidr_block         = "172.30.0.0/20"
#   availability_zone  = "me-south-1a"

#   tags = {
#     Name = "UMF default private Subnet me-south-1"
#     key  = "Enviroment"
#     value  = "default-vpc"
#   }
# }

resource "aws_internet_gateway" "umf_prod_igw" {
  vpc_id = aws_vpc.umf_prod_vpc.id

  tags = {
    Name = "UMF prod Internet Gateway"
    key  = "Enviroment"
    value  = "prod"
  }
}

resource "aws_route_table" "umf_public_rt" {
  vpc_id = aws_vpc.umf_prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.umf_prod_igw.id
  }

  # route {
  #   ipv6_cidr_block = "::/0"
  #   gateway_id      = aws_internet_gateway.umf_prod_igw.id
  # }

  tags = {
    Name = "UMF prod Public Route Table"
    key  = "Enviroment"
    value  = "prod"
  }

  depends_on = [aws_internet_gateway.umf_prod_igw]
}

/* creating route_table in default_vpc (rds vpc) in which our destination is
the cidr of public_subnet of prod_vpc and target is the id of peering_connection */

resource "aws_route_table" "accepter_rt" {
  vpc_id  = data.default_vpc_id

  route {
    cidr_block                = "10.0.0.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.umf_peer.id
  }

  depends_on = [aws_vpc_peering_connection.umf_peer]
  tags = {
      Name  = "default_vpc_private_rt"
  }
}

/* creating route_table in prod_vpc in which our destination is the cidr of
private_subnet of default_vpc (rds vpc) and target is the id of peering_connection */


resource "aws_route_table" "requester_rt" {
  vpc_id  = aws_vpc.umf_prod_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.umf_prod_igw.id
  }

  route {
    cidr_block                 = "172.31.0.0/20"
    vpc_peering_connection_id  = aws_vpc_peering_connection.umf_peer.id
  }

  depends_on = [aws_vpc_peering_connection.umf_peer]
  tags = {
      Name   = "requester_routetable"
  }
}

# Assign the public route table to the public subnet
resource "aws_route_table_association" "umf_prod_public_2a_rta" {
  subnet_id      = aws_subnet.umf_prod_public_subnet_eu_west_2a.id
  route_table_id = aws_route_table.umf_public_rt.id
}

resource "aws_route_table_association" "umf_prod_public_2b_rta" {
  subnet_id      = aws_subnet.umf_prod_public_subnet_eu_west_2b.id
  route_table_id = aws_route_table.umf_public_rt.id
}

// associating requester_route_table with public_subnet


resource "aws_route_table_association" "requester_rta" {
  subnet_id       = aws_subnet.umf_prod_public_subnet_eu_west_2a.id
  route_table_id  = aws_route_table.requester_rt.id
}

//associating accepter_route_table with private_subnet
resource "aws_route_table_association" "accepter_rta" {
    subnet_id       = var.default_vpc_subnet_id
    route_table_id  = aws_route_table.accepter_rt.id
}
# resource "aws_subnet" "umf_prod_private_subnet_eu_west_2a" {
#   vpc_id            = aws_vpc.umf_prod_vpc.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "eu-west-2a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "UMF prod private Subnet us-west-2b"
#     key   = "Enviroment"
#     value = "prod"
#   }
# }

# resource "aws_subnet" "umf_prod_private_subnet_eu_west_2b" {
#   vpc_id            = aws_vpc.umf_prod_vpc.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "eu-west-2b"

#   tags = {
#     Name = "UMF prod private Subnet us-west-2b"
#     key   = "Enviroment"
#     value = "prod"
#   }
# }

# resource "aws_nat_gateway" "umf_prod_ngw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.umf_prod_private_subnet_eu_west_2a.id

#   tags = {
#     Name = "NatGateway"
#     value = "prod"
#   }
# }

# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# resource "aws_route_table" "umf_private_rt" {
#   vpc_id = aws_vpc.umf_prod_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.umf_prod_igw.id
#   }

#   route {
#     ipv6_cidr_block = "::/0"
#     gateway_id      = aws_internet_gateway.umf_prod_igw.id
#   }

#   tags = {
#     Name = "UMF prod Public Route Table"
#     key   = "Enviroment"
#     value = "prod"
#   }

#   gateway_id = aws_nat_gateway.umf_prod_ngw
# }

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["eu-west-2a", "eu-west-2b"]
#   public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
#   private_subnets = ["10.0.101.0/24"]


#   enable_nat_gateway   = false
#   single_nat_gateway   = true
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   public_subnet_tags = {
#     Name = "umf-prod-public-subnet"
#   }

#   vpc_tags = {
#     Name = "umf-prod-vpc"
#   }
# }
