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

variable "name" {
    description = "ALB 이름"
    type        = string
    default     = "ABC-ALB"
}

variable "vpc_id" {
    description = "VPC ID 입력"
    type        = string
    default     = "ABC-VPC"
}

variable "subnet_id" {
    description = "Subnet ID 입력"
    type        = string
    default     = ""
}
