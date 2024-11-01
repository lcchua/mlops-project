#============ S3 BUCKET =============

# Generate a random identifier
resource "random_id" "suffix_s3" {
  byte_length = 2
}

# Bucket with versioning enabled
resource "aws_s3_bucket" "this" {
  bucket = "${var.ml_s3bucket_name}-${random_id.suffix_s3.dec}"

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
resource "aws_s3_bucket_ownership_controls" "this-owner-ctl" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Disable block all public accesses
resource "aws_s3_bucket_public_access_block" "this-pub-access-blk" {
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
  acl    = "authenticated-read"
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

# Enable bucket access logging and creation of a specific "logging bucket"
resource "aws_s3_bucket_logging" "this_logging" {
  bucket = aws_s3_bucket.this.id

  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "${aws_s3_bucket.this.id}-logging-bucket"
}
output "logging_bucket" {
  description = "dev stw loggin S3 bucket"
  value       = aws_s3_bucket.logging_bucket.id
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
