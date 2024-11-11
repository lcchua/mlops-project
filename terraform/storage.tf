#============ S3 BUCKET =============

# Generate a random identifier
#resource "random_id" "suffix_s3" {
#  byte_length = 2
#}

# S3 bucket creation
      #checkov:skipped=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
      #checkov:skipped=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled            
      #  Custom IAM policy attached to this S3 resource
resource "aws_s3_bucket" "this" {
  #  bucket = "${var.ml_s3bucket_name}-${random_id.suffix_s3.dec}"
  bucket = var.ml_s3bucket_name

  tags = {
    group = var.stack_name
    Env   = "Dev"
    Name  = "stw-s3-bucket"
  }
}
output "s3bucket" {
  description = "dev stw S3 bucket"
  value       = aws_s3_bucket.this.id
}

# Fix CKV_AWS_145
resource "aws_s3_bucket_server_side_encryption_configuration" "good_sse_1" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "this-bucket-versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
output "s3bucket-versioning" {
  description = "dev stw S3 bucket versioning"
  value       = aws_s3_bucket_versioning.this-bucket-versioning.versioning_configuration
}

# Enable bucket ownership control
      #CKV2_AWS_65:Ensure access control lists for S3 buckets are disabled
      #  Custom IAM policy attached to this S3 resource
resource "aws_s3_bucket_ownership_controls" "this-owner-ctl" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Disable block all public accesses
resource "aws_s3_bucket_public_access_block" "this-pub-access-blk" {
      #checkov:skipped=CKV_AWS_56:Ensure S3 bucket has 'restrict_public_buckets' enabled
      #checkov:skipped=CKV_AWS_55:Ensure S3 bucket has ignore public ACLs enabled
      #checkov:skipped=CKV_AWS_54:Ensure S3 bucket has block public policy enabled
      #checkov:skipped=CKV_AWS_53:Ensure S3 bucket has block public ACLS enabled
      #  Custom IAM policy attached to this S3 resource
  bucket = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set up bucket canned ACL for AthenticatedUsersGrp read
resource "aws_s3_bucket_acl" "this-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this-owner-ctl,
    aws_s3_bucket_public_access_block.this-pub-access-blk
  ]

  bucket = aws_s3_bucket.this.id
  acl    = "private" # Fix CKV_AWS_20
}
output "s3bucket-acl" {
  description = "dev stw S3 bucket acl set to public read"
  value       = aws_s3_bucket_acl.this-acl.id
}

# Create a bucket folder for new ML datasets
resource "aws_s3_object" "folder1" {
  bucket = aws_s3_bucket.this.id
  key    = "${var.MLdata_s3bucket_folder_name}/"
  acl    = "private"
  source = "/dev/null"
}

# Create a bucket folder for DVC artefacts
resource "aws_s3_object" "folder2" {
  bucket = aws_s3_bucket.this.id
  key    = "${var.DVC_s3bucket_folder_name}/"
  acl    = "private"
  source = "/dev/null"
}

# Configure the S3 bucjet logging
#   https://kodekloud.com/blog/how-to-create-aws-s3-bucket-using-terraform/ 
      #checkov:skipped=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "${aws_s3_bucket.this.id}-logging-bucket"
}
output "logging_bucket" {
  description = "dev stw loggin S3 bucket"
  value       = aws_s3_bucket.logging_bucket.id
}

resource "aws_s3_buck_acl" "log_bucket_acl" {
  bucket= aws_s3_bucket.logging_bucket.id
  acl = "log-delivery-write"
}

# Enable bucket access logging and creation of a specific "logging bucket"
resource "aws_s3_bucket_logging" "this_logging" {
  bucket = aws_s3_bucket.this.id

      #checkov:skipped=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "log/"
}

# Fix CKV_AWS_145
resource "aws_s3_bucket_server_side_encryption_configuration" "good_sse_2" {
  bucket = aws_s3_bucket_logging.this_logging.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

# Define the custom bucket IAM policy for DVC accesses
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid = "DVCPushPull"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::255945442255:user/CyuanT777",
        "arn:aws:iam::255945442255:user/junjie24",
        "arn:aws:iam::255945442255:user/stphntn",
        "arn:aws:iam::255945442255:user/lcchua7"
      ]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}
