resource "aws_vpc_peering_connection" "umf_peer" {
  # provider      = aws.source
  vpc_id        = aws_vpc.umf_prod_vpc.id
  peer_vpc_id   = data.default_vpc_id
  auto_accept   = true
  peer_region   = "eu-west-2"

  tags = merge(var.tags, {
    Name = "VPC Peering between ${aws_vpc.umf_prod_vpc.name} and ${var.target_name} VPCs"
  })
}

# resource "aws_vpc_peering_connection_accepter" "peering" {
#   provider                  = aws.target
#   vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
#   auto_accept               = true

#   tags = merge(var.tags, {
#     Name = "VPC Peering between ${var.source_name} and ${var.target_name} VPCs"
#   })
# }

# resource "aws_vpc_peering_connection_options" "peering_requester" {
#   provider                  = aws.source
#   vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }
# }

# resource "aws_vpc_peering_connection_options" "peering_accepter" {
#   provider                  = aws.target
#   vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }
# }
