locals {
  route53name = "kuruma-kadai.tk"
}
resource "aws_route53_zone" "route53_zone" {
  name          = local.route53name
  force_destroy = false
  tags = {
    "Name" = local.route53name
  }
}

resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = local.route53name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.terraform_eip.public_ip]
}