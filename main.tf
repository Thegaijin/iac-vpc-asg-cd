# resource "aws_vpc" "umf_prod_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true

#   tags = {
#     Name = "UMF prod VPC"
#     key   = "Enviroment"
#     value = "prod"
#   }
# }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.101.0/24"]


  enable_nat_gateway   = false
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name = "umf-prod-public-subnet"
  }

  vpc_tags = {
    Name = "umf-prod-vpc"
  }
}

# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = module.vpc.private_subnets

#   tags = {
#     "Name" = "NatGateway"
#   }
# }

# resource "aws_subnet" "umf_prod_public_subnet_eu_west_2a" {
#   vpc_id            = aws_vpc.umf_prod_vpc.id
#   cidr_block        = "10.0.0.0/24"
#   availability_zone = "me-south-1a"

#   tags = {
#     Name = "UMF prod Subnet us-west-2a"
#     key   = "Enviroment"
#     value = "prod"
#   }
# }

# resource "aws_subnet" "umf_prod_public_subnet_eu_west_2b" {
#   vpc_id            = aws_vpc.umf_prod_vpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "me-south-1b"

#   tags = {
#     Name = "UMF prod Subnet us-west-2b"
#     key   = "Enviroment"
#     value = "prod"
#   }
# }

# resource "aws_internet_gateway" "umf_prod_igw" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name = "UMF prod Internet Gateway"
#     key   = "Enviroment"
#     value = "prod"
#   }
# }

# resource "aws_route_table" "umf_public_rt" {
#   vpc_id = module.vpc.vpc_id

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
# }

# Assign the public route table to the public subnet
# resource "aws_route_table_association" "umf_prod_public_rta" {
#   subnet_id      = module.vpc.public_subnets
#   route_table_id = aws_route_table.umf_public_rt.id
# }
