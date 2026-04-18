resource "aws_acm_certificate" "mycert" {
  domain_name = trimsuffix(var.mydomain,".")
  validation_method = "DNS"
  
  subject_alternative_names = ["*.duydinh.online"]
  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true

  for_each = {
    for dvo in aws_acm_certificate.mycert.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = var.domain_zoneid
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}