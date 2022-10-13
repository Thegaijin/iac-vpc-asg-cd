module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.deployment_bucket
  acl    = "private"

  versioning = {
    enabled = true
  }

}

resource "aws_s3_bucket_public_access_block" "umf_prod_policy" {
  bucket = var.deployment_bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
