variable "account_number" {
  type = string
}
variable "name" {
  type    = string
  default = "jonathanmath"
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}