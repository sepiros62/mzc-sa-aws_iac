## Load ALB, ROUTE53 Data ##

# data "aws_cloudfront_distribution" "cloudfront" {
#   id = "EDFDVBD632BHDS5"
# }

data "aws_lb" "alb" {
  name = "${var.name}-ALB"
}

data "aws_route53_zone" "public" {
  name         = "${var.domain}."
  private_zone = false
}


## Create Route53 Public Zone ##
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.public.zone_id
  name = "api.${var.domain}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.public.zone_id
#   name = "www.${var.domain}"
#   type    = "A"

#   alias {
#     name                   = data.aws_lb.alb.dns_name
#     zone_id                = data.aws_lb.alb.zone_id
#     evaluate_target_health = false
#   }
# }
