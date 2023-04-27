

data "aws_route53_zone" "zone" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = data.aws_route53_zone.zone.name
  type    = "CNAME"
  ttl     = "60"
  records = [var.lb_dns_name]
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.subdomain}.${data.aws_route53_zone.zone.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [var.lb_dns_name]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = data.aws_route53_zone.zone.name
  subject_alternative_names = [
    "*.${data.aws_route53_zone.zone.name}", 
  ]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      fqdn    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
    }
  }

  name    = each.value.fqdn
  type    = each.value.type
  records = [each.value.record]
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  depends_on = [
    aws_acm_certificate.cert
  ]
}

# validate acm certificates
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
