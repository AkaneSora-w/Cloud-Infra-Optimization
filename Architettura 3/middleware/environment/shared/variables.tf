######################################
# Global
######################################

variable "region" {
  type = string
}

variable "environment" {
  type = string
}
variable "service_name" {
  type = string
}

variable "owner" {
  type = string
}


######################################
# VPC
######################################

variable "vpc_cidr" {
  type        = string
  description = "CIDR of the VPC to create"
}
variable "public_subnets" {
  type        = list(string)
  description = "CIDR of the public-facing subnets"
}

variable "app_private_subnets" {
  type        = list(string)
  description = "CIDR of the application private subnets"
}

variable "db_private_subnets" {
  type        = list(string)
  description = "CIDR of the database private subnets"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

######################################
# ACM
######################################

variable "certificates" {
  type = map(object({
    domain_name               = string
    subject_alternative_names = optional(list(string), [])
    zone_id                   = optional(string, "")
    validation_method         = optional(string, "DNS")
  }))
}

######################################
# Conditional variables
######################################

variable "create_kms_key" {
  type        = bool
  description = "Create a KMS key for the S3 bucket"
}

variable "create_alb" {
  type        = bool
  description = "Create an Application Load Balancer"
  default     = true
}

variable "create_kms_key_shared" {
  type        = bool
  description = "Create a shared KMS key for the S3 bucket"
  default     = false
}