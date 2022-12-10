##### Web Tier Load Balancer #####
resource "aws_lb" "web_tier" {
  name               = "web_tier-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_web_tier.id]
  subnets            = aws_subnet.public_subnet.*.id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "web_tier" {
  load_balancer_arn = aws_lb.web_tier.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tier.arn
  }
}

resource "aws_lb_target_group" "web_tier" {
  name        = "web_tier-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.mainvpc.id
  target_type = "instance"
  
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = 80  
  }
}

##### App tier Load Balancer #####

resource "aws_lb" "app_tier" {
  name               = "app_tier-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_app_tier.id]
  subnets            = aws_subnet.private_subnet.*.id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "app_tier" {
  load_balancer_arn = aws_lb.app_tier.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tier.arn
  }
}

resource "aws_lb_target_group" "app_tier" {
  name        = "app_tier-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.mainvpc.id
  target_type = "instance"

  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = 80  
  }
}

#### Target group attachment #####

resource "aws_lb_target_group_attachment" "web_tier" {
  target_group_arn = aws_lb_target_group.web_tier.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
  count            = 2
}

resource "aws_lb_target_group_attachment" "app_tier" {
  target_group_arn = aws_lb_target_group.app_tier.arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
  count            = 2
}