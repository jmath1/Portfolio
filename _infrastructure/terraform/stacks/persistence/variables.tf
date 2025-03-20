variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_user" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "secret_key" {
  description = "The secret key for the django app"
  type        = string
}

variable "domain_name" {
    description = "The domain name for the django app"
    type        = string
}

variable "tld" {
    description = "The top level domain for the django app"
    type        = string
}