resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "db_subnet_group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "db_subnet_group"
  }
}

resource "aws_security_group" "rds-sg" {
  name        = "RDS_Security_Group"
  description = "Allows app tier to access the RDS instance"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description     = "Private EC2 to MYSQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_tier.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}

data "aws_ssm_parameter" "rds_db_username" {
  name            = var.rds_db_username_path
  with_decryption = true
}

data "aws_ssm_parameter" "rds_db_password" {
  name            = var.rds_db_password_path
  with_decryption = true
}
resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "db_subnet_group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "db_subnet_group"
  }
}

resource "aws_security_group" "rds-sg" {
  name        = "RDS_Security_Group"
  description = "Allows app tier to access the RDS instance"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description     = "Private EC2 to MYSQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_tier.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}

data "aws_ssm_parameter" "rds_db_username" {
  name            = var.rds_db_username_path
  with_decryption = true
}

data "aws_ssm_parameter" "rds_db_password" {
  name            = var.rds_db_password_path
  with_decryption = true
}
