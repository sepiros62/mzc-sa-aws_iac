provider "aws" {
  region = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile   =   "jaehwan"
}

variable "region" {
    description = "리전 선택"
    type        = string
    default     = "ap-northeast-2"
}

variable "domain" {
    description = "DNS 이름"
    type        = string
    default     = "abc-shop.cf"
}

variable "bucket_name" {
    description = "Bucket 이름"
    type        = string
    default     = "b-abc-shop.cf"
}
