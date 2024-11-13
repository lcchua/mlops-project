output "repository_url" {
  value = aws_ecr_repository.this.repository_url
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
}

output "registry_id" {
  value = aws_ecr_repository.this.id
  description = "The registry ID where the repository was created."
}
