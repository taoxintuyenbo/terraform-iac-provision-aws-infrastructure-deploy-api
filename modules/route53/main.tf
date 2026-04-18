#To get the zone_id of the exist hosted zone
data "aws_route53_zone" "mydomain" {
  name = "duydinh.online"
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "api"
  type    = "A"
  
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}