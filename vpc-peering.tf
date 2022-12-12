resource "aws_vpc_peering_connection" "umf_peer" {
  vpc_id        = aws_vpc.umf_prod_vpc.id
  peer_vpc_id   = var.default_vpc_id
  auto_accept   = false
  peer_region   = "me-south-1"

  # tags = {
  #   Name  = "VPC Peering between ${aws_vpc.umf_prod_vpc.tags.Name} and ${var.target_name} VPCs"
  #   key   = "Environment"
  #   value = "prod"
  # }

  tags = merge(var.tags, {
    Name = "VPC Peering between ${aws_vpc.umf_prod_vpc.tags.Name} and ${var.target_name} VPCs"
  })
}

# resource "aws_vpc_peering_connection_accepter" "peering" {
#   provider                  = aws.target
#   vpc_peering_connection_id = aws_vpc_peering_connection.umf_peer.id
#   auto_accept               = true

#   tags = merge(var.tags, {
#     Name = "VPC Peering between ${aws_vpc.umf_prod_vpc.name} and ${var.target_name} VPCs"
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
