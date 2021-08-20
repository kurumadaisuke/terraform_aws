resource "aws_key_pair" "kerpair" {
  key_name   = "terraform_keypair"
  public_key = file("./src/terraform-kerpair.pub")
  tags = {
    "Name" = "terraform_kerpair"
  }
}
resource "aws_eip" "terraform_eip" {
  instance = aws_instance.EC2.id
  vpc      = true
  tags = {
    "Name" = "terraform_eip"
  }
}
output "public_ip" {
  value = aws_eip.terraform_eip.public_ip
}

resource "aws_instance" "EC2" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public-a.id
  vpc_security_group_ids      = [aws_security_group.web_sg_terraform.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.kerpair.key_name

  tags = {
    Name = "terraform_EC2"
  }

  user_data = <<EOF
    #!/bin/bash
    yum -y update
    amazon-linux-extras install php7.2 -y
    yum -y install mysql httpd php-mbstring php-xml
    wget http://ja.wordpress.org/latest-ja.tar.gz -P /tmp/
    tar zxvf /tmp/latest-ja.tar.gz -C /tmp
    cp -r /tmp/wordpress/* /var/www/html/
    chown apache:apache -R /var/www/html
    systemctl enable httpd.service
    systemctl start httpd.service
  EOF
}

# resource "aws_eip" "web_terraform" {
#   instance =aws_instance.EC2.id
#   vpc = true  
# }