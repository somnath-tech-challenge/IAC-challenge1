resource "aws_autoscaling_group" "web_tier" {
  name                      = "Launch-Template-Web-Tier"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.public_subnet.*.id

  launch_template {
    id      = aws_launch_template.web_tier.id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
  tag {
    key                 = "Name"
    value               = "Web_Tier"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "app_tier" {
  name                      = "Launch-Template-App-Tier"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.private_subnet.*.id

  launch_template {
    id      = aws_launch_template.app_tier.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
  
  tag {
    key                 = "Name"
    value               = "App_Tier"
    propagate_at_launch = true
  }
}

#Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "web_tier" {
  autoscaling_group_name = aws_autoscaling_group.web_tier.id
  lb_target_group_arn    = aws_lb_target_group.web_tier.arn
}

resource "aws_autoscaling_attachment" "app_tier" {
  autoscaling_group_name = aws_autoscaling_group.app_tier.id
  lb_target_group_arn    = aws_lb_target_group.app_tier.arn
}