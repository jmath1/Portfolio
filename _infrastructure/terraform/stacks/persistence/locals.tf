locals {
  env_vars = {
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_NAME     = var.db_name
    SECRET_KEY  = var.secret_key
  }
}