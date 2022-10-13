resource "tls_private_key" "key" {
algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
filename          = "umf-prod.pem"
content           = tls_private_key.key.private_key_pem
file_permission   = "0400"
}

module "key_pair" {
  source     = "terraform-aws-modules/key-pair/aws"

  key_name   = "umf-prod"
  public_key = trimspace(tls_private_key.key.public_key_openssh)
}
