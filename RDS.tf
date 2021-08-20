resource "aws_db_subnet_group" "terraform_rds" {
  name       = "terraform_rds"
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]

  tags = {
    Name = "terraform_RDS"
  }
}

resource "aws_db_instance" "terraform_RDS" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t3.micro"
  name                 = "terraform_db"
  username             = "kuruma"
  password             = "terraform_password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.web_sg_terraform.id ]
  db_subnet_group_name = aws_db_subnet_group.terraform_rds.name
}