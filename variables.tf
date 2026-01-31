variable "private_subnet_count" {
  type    = number
  default = 6

}

variable "public_subnet_count" {
  type    = number
  default = 3

}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.112.0.0/24",
    "10.112.1.0/24",
    "10.112.2.0/24",
    "10.112.3.0/24",
    "10.112.4.0/24",
    "10.112.5.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.112.100.0/24",
    "10.112.105.0/24",
    "10.112.110.0/24",
    "10.112.115.0/24",
    "10.112.120.0/24",
    "10.112.125.0/24"
  ]
}

variable "aurora_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.112.200.0/24",
    "10.112.210.0/24",
    "10.112.220.0/24",
    "10.112.230.0/24",
    "10.112.240.0/24",
    "10.112.250.0/24"
  ]
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "labdb"
}



