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

variable "use_centralized_nat" {
  type        = bool
  description = "If true not create dedicated nat but use shared nat trougth transit gateway"
  default     = false
}


variable "vpc_mode" {
  type        = string
  description = "VPC network mode. If dedicated the VPC need have at least a dedicated Internet Gateway and VPN. If centralized Internet and VPN need to be centralized in organization, and VPN haven't a security group"
  default     = "centralized"
  validation {
    condition     = contains(["dedicated", "centralized"], var.vpc_mode)
    error_message = "Allowed value for vpc_mode is ['dedicated', 'centralized']"
  }
}

variable "create_alb" {
  type        = bool
  description = "Create an Application Load Balancer"
  default     = true
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
# EC2 OPENVPN
######################################
variable "ec2_openvpn_config" {
  type = object({
    ami           = string
    instance_type = string
    volume_size   = number
  })
}

######################################
# Scheduler
######################################
variable "schedule_tag" {
  type = object({
    ec2 = string
  })

  description = "Schedule tag to switch on/off resources"
}

variable "create_kms_key" {
  type        = bool
  description = "Create a KMS key for the S3 bucket"
  default     = false
}
