####### Web tier Security group configurations #####

resource "aws_security_group" "web_tier" {
  name        = "enable_connection_to_web_tier"
  description = "enable HTTP"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description     = "HTTP from anywhere port 80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_web_tier.id]
  }

  ingress {
    description     = "HTTP from anywhere port 3000"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_web_tier.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_tier_sg"
  }
}

resource "aws_security_group" "alb_web_tier" {
  name        = "enable_connection_to_alb_web_tier"
  description = "enable HTTP"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description      = "HTTP from anywhere port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from anywhere port 3000"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_web_tier_sg"
  }
}

##### App Tier security group configurations ##### 

resource "aws_security_group" "app_tier" {
  name        = "enable_connection_to_app_tier"
  description = "enable HTTP"
  vpc_id      = aws_vpc.mainvpc.id
  ingress {
    description     = "HTTP from public subnet port 80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_app_tier.id]
  }

  ingress {
    description     = "HTTP from public subnet port 3000"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_app_tier.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app_tier_sg"
  }
}

resource "aws_security_group" "alb_app_tier" {
  name        = "enable_connection_to_alb_app_tier"
  description = "enable HTTP"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description     = "HTTP from web tier port 80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier.id]
  }

  ingress {
    description     = "HTTP from web tier port 3000"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_app_tier_sg"
  }
}