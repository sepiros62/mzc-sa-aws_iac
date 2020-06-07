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

variable "name" {
    description = "프로젝트 이름"
    type        = string
    default     = "ABC"
}

variable "ip_address" {
  description = "IPv4 A레코드 입력"
  type        = string
  default     = "221.148.35.240"
}
