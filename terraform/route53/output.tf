output "route53_zone_id" {
  value = data.aws_route53_zone.public.zone_id
}

output "route53_dns_name" {
  value = data.aws_route53_zone.public.name
}
