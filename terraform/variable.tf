variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for VPC"
  //default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type        = string
  description = "CIDR for subnet"
  //default     = "10.0.1.0/24"
}

variable "open_cidr_block" {
  type        = string
  description = "open cidr block"
}