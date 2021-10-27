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
  type        = map(any)
  description = "subnet region cidr block "
}

variable "open_ipv6_cidr_block" {
  type        = string
  description = "open cidr block"
}

variable "bucket_name" {
  type        = string
  description = "bucket name"
}

variable "bucket_acl" {
  type        = string
  description = "bucket acl"
}

variable "lifecycle_name" {
  type        = string
  description = "the name and id of lifecycle"
}

variable "db_parameter_group_name" {
  type        = string
  description = "the name of db parameter group"
}

variable "db_parameter_group_family" {
  type        = string
  description = "the family of db parameter group"
}
variable "db_allocated_storage" {
  type        = number
  description = "the allocated storage of database"
}
variable "db_engine" {
  type        = string
  description = "the engine of database"
}

variable "db_engine_version" {
  type        = string
  description = "the engine version of database"
}

variable "db_instance_class" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_identifier" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "ami_id" {
  type = string
}
