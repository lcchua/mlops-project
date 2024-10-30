#============ S3 BUCKET =============

# Generate a random identifier
resource "random_id" "suffix_s3" {
  byte_length = 2
}

# Bucket with versioning enabled and acl set to public read
resource "aws_s3_bucket" "lcchua-tf-s3bucket" {
  bucket = "lcchua-bucket-${random_id.suffix_s3.dec}"

  tags = {
    group = var.stack_name
    Env   = "Dev"
    Name  = "stw-s3-bucket"
  }
}
output "s3bucket" {
  description = "dev stw S3 bucket"
  value       = aws_s3_bucket.lcchua-tf-s3bucket.id
}

# Enable bucket ownership control and public read
resource "aws_s3_bucket_ownership_controls" "lcchua-tf-s3bucket-owner-ctl" {
  bucket = aws_s3_bucket.lcchua-tf-s3bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "lcchua-tf-s3bucket-pub-access-blk" {
  bucket = aws_s3_bucket.lcchua-tf-s3bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set up bucket ACL
resource "aws_s3_bucket_acl" "lcchua-tf-s3bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.lcchua-tf-s3bucket-owner-ctl,
    aws_s3_bucket_public_access_block.lcchua-tf-s3bucket-pub-access-blk
  ]

  bucket = aws_s3_bucket.lcchua-tf-s3bucket.id
  acl    = "public-read"
}
output "s3bucket-acl" {
  description = "dev stw S3 bucket acl set to public read"
  value       = aws_s3_bucket_acl.lcchua-tf-s3bucket-acl.id
}
