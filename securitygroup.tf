#securitygroup
resource "aws_security_group" "web_sg_terraform" {
  name        = "web_sg_terraform"
  description = "web_SG"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "WEB_SG_terraform"
  }
}

#INBOUND
resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg_terraform.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web_in_ssh" {
  security_group_id = aws_security_group.web_sg_terraform.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#OUTBOUND

resource "aws_security_group_rule" "all" {
  security_group_id = aws_security_group.web_sg_terraform.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
}