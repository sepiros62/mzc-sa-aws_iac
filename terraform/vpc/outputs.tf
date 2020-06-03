output "vpc_id" {
  value = aws_vpc.selected.id
}

output "private_was_ids" {
  value = data.aws_subnet_ids.private_was.ids
}

output "private_db_ids" {
   value = data.aws_subnet_ids.private_db.ids
 }

output "nat_gateway_ip" {
  value = aws_eip.private.public_ip
}
