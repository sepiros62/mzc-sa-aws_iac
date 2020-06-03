provider "aws" {
  region = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile   =   "jaehwan"
}

variable "region" {
  description = "리전 입력"
  type        = string
  default     = "ap-northeast-2"
}

variable "name" {
  description = "프로젝트 이름을 입력"
  type        = string
  default     = "ABC"
}

variable "administrator" {
  description = "AdministratorAccess 권한 부여 여부를 입력"
  type        = bool
  default     = true
}

variable "allow_ip_address" {
  description = "SSH 로 접속 허용할 IP 목록을 입력"
  type        = list(string)
  default = [
    "0.0.0.0/0"
  ]
}

variable "ami_id" {
  description = "Instance AMI ID 를 입력"
  type        = string
  default     = "ami-01af223aa7f274198"
}

variable "instance_type" {
  description = "인스턴스 유형 입력"
  type        = string
  default     = "t2.micro"
}

variable "volume_type" {
  description = "불륨 유형 입력"
  type        = string
  default     = "gp2"
}

variable "volume_size" {
  description = "불륨 크기 입력"
  type        = string
  default     = "8"
}

variable "key_name" {
  description = "키페어 이름 입력"
  type        = string
  default     = "Megazone-Keypair"
}

variable "user_data" {
  description = "인스턴스 시작시 실핼될 스크립트를 입력"
  type        = string
  default     = "setup.sh"
}
