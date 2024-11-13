resource "aws_ecr_repository" "this" {
  name                 = "${var.project_family}/${var.environment}/${var.name}"
  image_tag_mutability = var.image_tag_mutability # Fix CKV_AWS_51
  force_delete = var.force_delete

  encryption_configuration {
    encryption_type = var.encryption_type # Fix CKV_AWS_136
    # Without defining "kms_key" so use the default
    # AWS-managed encryption key (aws/ecr) instead.
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.additional_tags
/*   tags = merge(
    var.additional_tags,
    {
      ManagedBy = "Terraform"
      Environment = "${var.environment}"
    }
  ) */
}

resource "aws_ecr_lifecycle_policy" "this_lifecycle_policy" {
  count = var.expiration_after_days > 0 ? 1 : 0
  repository = aws_ecr_repository.this.name

  # count_type:
  #   imageCountMoreThan - if there are more than a specified number of images, some will be expired.
  #   sinceImagePushed - keeps the most recently pushed images
  #   imageTagPrefix - keeps images with specific tag prefixes
  policy = <<EOF
  {
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${var.expiration_after_days} days",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.expiration_after_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
  }
  EOF
}

resource "aws_ecr_repository_policy" "this_repo_policy" {
  repository = aws_ecr_repository.this.name

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowAccessToSpecificUsers",
        "Principal": {
          "AWS": [
            "arn:aws:iam::255945442255:user/CyuanT777",
            "arn:aws:iam::255945442255:user/junjie24",
            "arn:aws:iam::255945442255:user/stphntn",
            "arn:aws:iam::255945442255:user/lcchua7"
          ]
        },
        "Effect": "Allow",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  }
  EOF
}
