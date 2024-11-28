# MUST_DO FIRST STEP - 
# TO CHANGE THE APPROPRIATE TF CONFIGURATION PARAMETERS BELOW

variable "stack_name" {
  type    = string
  default = "ce7-proj-grp-1-stw"
}

variable "region" {
  description = "Name of aws region"
  type        = string
  default     = "us-east-1"
}

variable "ml_s3bucket_name" {
  description = "Name of S3 bucket for ML artefacts and datasets"
  type        = string
  default     = "ce7-grp-1-bucket"
}

variable "MLdata_s3bucket_folder_name" {
  description = "Name of S3 bucket folder name for new ML datasets"
  type        = string
  default     = "new_ML_data"
}

variable "DVC_s3bucket_folder_name" {
  description = "Name of S3 bucket folder name for DVC artefacts"
  type        = string
  default     = "DVC_artefacts"
}

