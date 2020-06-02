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
    description = "프로젝트 이름"
    type        = string
    default     = "ABC"
}

variable "az_names" {
    description = "가용 영역"
    type        = list(string)
    default     = [
        "ap-northeast-2a",
        "ap-northeast-2c"
        ]
}

variable "vpc_cidr" {
    description = "VPC의 CIDR 블록"
    type        = string
    default     = "10.10.0.0/16"
}

variable "public_subnets" {
    description = "퍼블릭 서브넷"
    type        = list(object({
        zone = string
        cidr = string
        tier = string
    }    ))
    default = [
        {
            zone = "ap-northeast-2a"
            cidr = "10.10.0.0/24"
            tier = "IGW-Subnet-Public"
        },
        {
            zone = "ap-northeast-2c"
            cidr = "10.10.1.0/24"
            tier = "IGW-Subnet-Public"
        },
        {
            zone = "ap-northeast-2a"
            cidr = "10.10.2.0/24"
            tier = "ALB-Subnet-Public"
        },
                {
            zone = "ap-northeast-2c"
            cidr = "10.10.3.0/24"
            tier = "ALB-Subnet-Public"
        }
    ]
}

variable "private_subnets" {
    description = "프라이빗 서브넷"
    type        = list(object({
        zone = string
        cidr = string
        tier = string
    }    ))
    default = [
        {
            zone = "ap-northeast-2a"
            cidr = "10.10.4.0/24"
            tier = "WAS-Subnet-Private"
        },
        {
            zone = "ap-northeast-2c"
            cidr = "10.10.5.0/24"
            tier = "WAS-Subnet-Private"
        },
        {
            zone = "ap-northeast-2a"
            cidr = "10.10.6.0/24"
            tier = "DB-Subnet-Private"
        },
                {
            zone = "ap-northeast-2c"
            cidr = "10.10.7.0/24"
            tier = "DB-Subnet-Private"
        }
    ]
}

data "aws_availability_zones" "azs" {
}
