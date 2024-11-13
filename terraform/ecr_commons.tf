# Comment this if it is for single ecr repo
locals {
  project_family = "ce7-grp-1"
  appname        = "predict_buy_app"
  repositories = {
    "repo1" = {
      image_tag_mutability  = "IMMUTABLE"
      scan_on_push          = true
      force_delete          = true
      encryption_type       = "KMS"
      expiration_after_days = 7
      environment           = "prod"
#      tags = {
#        Project     = "CapstoneProj-SRE,DevOps,DevSecOps"
#        Owner       = "ce7-grp-1"
#        Purpose     = "ECR private repo creation for prod env"
#        Description = "Predict insurance-buy docker image"
#      }
    }

    "repo2" = {
      image_tag_mutability  = "IMMUTABLE"
      scan_on_push          = true
      force_delete          = true
      encryption_type       = "KMS"
      expiration_after_days = 3
      environment           = "nonprod"
#      tags = {
#        Project     = "CapstoneProj-SRE,DevOps,DevSecOps"
#        Owner       = "ce7-grp-1"
#        Purpose     = "ECR private repo creation for nonprod env"
#        Description = "Predict insurance-buy docker image"
      }
    }
  }
}

# Uncomment this if it is for single ecr repo
# module "ecr" {
#   source = "./modules/ecr"

#   name                  = "predict_buy_app"
#   project_family        = "ce-grp-1"
#   environment           = "non-prod"
#   image_tag_mutability  = "IMMUTABLE"
#   scan_on_push          = true
#   force_delete          = true
#   encryption_type       = "KMS"
#   expiration_after_days = 7
#   additional_tags = {
#     Project     = "CapstoneProj-SRE,DevOps,DevSecOps"
#     Owner       = "ce7-grp-1"
#     Purpose     = "ECR private repo creation"
#     Description = "Predict insurance-buy docker image"
#   }
# }


# Uncomment this if it is for multiple ecr repo
module "ecr" {
  source   = "./modules/ecr"
  for_each = local.repositories

  name                  = local.appname
  project_family        = local.project_family
  environment           = each.value.environment
  image_tag_mutability  = each.value.image_tag_mutability
  scan_on_push          = each.value.scan_on_push
  force_delete          = each.value.force_delete
  encryption_type       = each.value.encryption_type
  expiration_after_days = each.value.expiration_after_days
#  additional_tags       = each.value.tags

}
