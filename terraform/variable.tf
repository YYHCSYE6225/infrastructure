variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for VPC"
  //default     = "10.0.0.0/16"
}

variable "open_cidr_block" {
  type        = string
  description = "open cidr block"
}

variable "profile" {
  type        = string
  description = "profile name"
}

variable "region" {
  type        = string
  description = "region name"
}

variable "subnet_region_cidr_block" {
  type        = map
  description = "subnet region cidr block "
}
