output "ami_name" {
  value = data.aws_ami.was.name
}

output "alb_sg" {
  value = data.aws_security_group.alb.id
}

output "subnet_id" {
  value = data.aws_subnet_ids.private.ids
}
