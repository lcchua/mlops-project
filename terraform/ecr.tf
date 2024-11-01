# Creation of Private ECR repo
resource "aws_ecr_repository" "this" {
  name                 = var.ecr_repo_appname
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
output "ecr_repo_app_url" {
  description = "dev stw ECR public repo app_image"
  value       = aws_ecr_repository.this.repository_url
}

resource "aws_ecr_lifecycle_policy" "this_lifecycle_policy" {
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
        "description": "Keep last 5 images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["v"],
          "countType": "imageCountMoreThan",
          "countNumber": 10
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}

resource "aws_ecr_repository_policy" "this_ecr_repo_policy" {
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
