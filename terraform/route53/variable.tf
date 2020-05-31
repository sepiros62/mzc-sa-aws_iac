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
  description = "도메인 입력"
  type        = string
  default     = "abc-shop.cf"
}

variable "ip_address" {
  description = "IPv4 A레코드 입력"
  type        = string
  default     = "211.109.191.130"
}
