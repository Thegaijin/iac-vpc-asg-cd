module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "umf-prod-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.101.0/24"]


  enable_nat_gateway   = false
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name = "umf-public-subnet"
    Env = "prod"
  }

  private_subnet_tags = {
    Name = "umf-private-subnet"
    Env = "prod"
  }

  vpc_tags = {
    Name = "umf-prod-vpc"
  }
}

# resource "aws_vpc" "umf_prod_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true

#   tags = {
#     Name  = "UMF prod VPC"
#     key   = "Enviroment"
#     value   = "prod"
#   }
# }

# resource "aws_subnet" "umf_prod_public_subnet_eu_west_2a" {
#   vpc_id              = aws_vpc.umf_prod_vpc.id
#   cidr_block          = "10.0.0.0/24"
#   availability_zone   = "eu-west-2a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "UMF prod public Subnet us-west-2a"
#     key  = "Enviroment"
#     value  = "prod"
#   }
# }

# resource "aws_subnet" "umf_prod_public_subnet_eu_west_2b" {
#   vpc_id             = aws_vpc.umf_prod_vpc.id
#   cidr_block         = "10.0.1.0/24"
#   availability_zone  = "eu-west-2b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "UMF prod public Subnet us-west-2b"
#     key  = "Enviroment"
#     value  = "prod"
#   }
# }

# resource "aws_internet_gateway" "umf_prod_igw" {
#   vpc_id = aws_vpc.umf_prod_vpc.id

#   tags = {
#     Name = "UMF prod Internet Gateway"
#     key  = "Enviroment"
#     value  = "prod"
#   }
# }

# resource "aws_route_table" "umf_public_rt" {
#   vpc_id = aws_vpc.umf_prod_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.umf_prod_igw.id
#   }

#   tags = {
#     Name = "UMF prod Public Route Table"
#     key  = "Enviroment"
#     value  = "prod"
#   }

#   depends_on = [aws_internet_gateway.umf_prod_igw]
# }

/* creating route_table in default_vpc (rds vpc) in which our destination is
the cidr of public_subnet of prod_vpc and target is the id of peering_connection */
# resource "aws_route_table" "accepter_rt" {
#   provider = aws.acceptor
#   vpc_id  = var.default_vpc_id

#   route {
#     cidr_block                = "10.0.0.0/24"
#     vpc_peering_connection_id = aws_vpc_peering_connection.umf_peer.id
#   }

#   depends_on = [aws_vpc_peering_connection.umf_peer]
#   tags = {
#       Name  = "default_vpc_private_rt"
#   }
# }

/* creating route_table in prod_vpc in which our destination is the cidr of
private_subnet of default_vpc (rds vpc) and target is the id of peering_connection */
# resource "aws_route_table" "requester_rt" {
#   vpc_id  = aws_vpc.umf_prod_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.umf_prod_igw.id
#   }

#   route {
#     cidr_block                 = "172.31.0.0/20"
#     vpc_peering_connection_id  = aws_vpc_peering_connection.umf_peer.id
#   }

#   depends_on = [aws_vpc_peering_connection.umf_peer]
#   tags = {
#       Name   = "requester_routetable"
#   }
# }

# Assign the public route table to the public subnet
# resource "aws_route_table_association" "umf_prod_public_2a_rta" {
#   subnet_id      = aws_subnet.umf_prod_public_subnet_eu_west_2a.id
#   route_table_id = aws_route_table.umf_public_rt.id
# }

# resource "aws_route_table_association" "umf_prod_public_2b_rta" {
#   subnet_id      = aws_subnet.umf_prod_public_subnet_eu_west_2b.id
#   route_table_id = aws_route_table.umf_public_rt.id
# }

# // associating requester_route_table with public_subnet
# resource "aws_route_table_association" "requester_rta" {
#   subnet_id       = aws_subnet.umf_prod_public_subnet_eu_west_2a.id
#   route_table_id  = aws_route_table.requester_rt.id
# }

# //associating accepter_route_table with private_subnet
# resource "aws_route_table_association" "acceptor_rta" {
#   subnet_id       = var.default_vpc_subnet_id
#   route_table_id  = aws_route_table.accepter_rt.id
#   # vpc_peering_connection_id = aws_vpc_peering_connection_acceptor.peering.id
# }
