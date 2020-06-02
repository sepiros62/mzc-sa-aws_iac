output "acm_domain" {
  value = data.aws_acm_certificate.domain.domain
}

output "subnet_id" {
  value = data.aws_subnet_ids.public.ids
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}
