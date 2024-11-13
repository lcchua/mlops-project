variable "name" {
  type = string
  description = "(Required) Name of the repository. {project_family}/{environment}/{name}."
}

variable "project_family" {
  type = string
  description = "(Required) Project name of the repository. {project_family}/{environment}/{name}."
}

variable "environment" {
  type = string
  description = "(Optional) Repository environment. {project_family}/{environment}/{name}. Default is nonprod."
  default = "nonprod"
}

variable "image_tag_mutability" {
  type = string
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  default = "MUTABLE"
}

variable "scan_on_push" {
  type = bool
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default = true
}

variable "force_delete" {
  type = bool
  description = "(Optional) Indicates whether allowing for deletion even if there are existing images within the repository. Defaults to (true)"
  default = true
}

variable "encryption_type" {
  type = string
  description = "(Optional) Indicates the type of encryption applied to the ecr repo."
}

variable "additional_tags" {
  type = map(string)
  description = "(Optional) A map of tags to assign to the resource."
  default = {}
}


variable "expiration_after_days" {
  type = number
  description = "(Optional) Delete images older than X days."
  default = 0

}
