provider "aws" {
  region = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile   =   "jaehwan"
}

variable "region" {
    description = "리전 선택 ap-northeast-2"
    type        = string
    default     = "ap-northeast-2"
}

variable "name" {
    description = "프로젝트 이름"
    type        = string
    default     = "onboard"
}

variable "allow_ip_address" {
    description = "SSH 접속 IP"
    type        = list(string)
    
    default     = [
        "222.148.35.240/32", #MZC
    ]
}

variable "vpc_cidr" {
    description = "VPC의 기본 CIDR 정의"
    type        = string
    default     = "10.10.0.0/16"
}

variable "az_names" {
    description = "가용 영역"
    type        = list(string)
    default     = [
        "ap-northeast-2a",
        "ap-northeast-2c"
        ]
}

variable "public_subnets" {
    description = "퍼블릭 서브넷"
    type        = list(object({
        zone = string
        cidr = string
    }    ))
    default = [
        {
            zone = "ap-northeast-2a"
            cidr = "10.10.0.0/25"
        },
                {
            zone = "ap-northeast-2c"
            cidr = "10.10.0.128/25"
        }
    ]
}

variable "private_subnets" {
    description = "프라이빗 서브넷"
    type        = list(object({
        zone = string
        cidr = string
    }    ))
    default = [
        {
            zone = "ap-northeast-2a"
            cidr = "10.10.1.0/25"
        },
                {
            zone = "ap-northeast-2c"
            cidr = "10.10.1.128/25"
        }
    ]
}

variable "tags" {
    default     = {
        "Jaehwan" = "mzc-jaehwan"
    }
}
