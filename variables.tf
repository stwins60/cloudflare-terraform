variable "s3_buckets" {
  description = "S3 buckets to create"
  type        = list(any)
  default     = []
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "example.com"
}