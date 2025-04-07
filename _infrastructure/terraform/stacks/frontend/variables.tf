
# Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "react-app"
}

variable "react_app_path" {
  description = "Local path to the React application"
  type        = string
}

variable "portfolio_id" {
  description = "Portfolio ID for the frontend application"
  type        = string
  default     = 1
}

variable "cloudfront_price_class" {
  description = "CloudFront price class (100, 200, or All)"
  type        = string
  default     = "PriceClass_100" # US/Canada/Europe
}

variable "domain_name" {
  type = string
}

variable "tld" {
  type = string
}

variable "github_repository_repo" {
  type = string
  default = "Portfolio"
}

variable "github_token" {
  type = string
}