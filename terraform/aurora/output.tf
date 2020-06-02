output "vpc_id" {
  value = data.aws_vpc.selected.id
}

 output "subnet_id" {
   value = data.aws_subnet_ids.private.ids
 }
