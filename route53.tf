resource "aws_route53_zone" "route53_zone" {
  name          = "kuruma-kadai.tk"
  force_destroy = false
  tags = {
    "Name" = "kuruma-kadai.tk"
  }
}

resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "kuruma-kadai.tk"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.terraform_eip.public_ip]
}