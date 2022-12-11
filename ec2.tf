locals {
  user_data_web = <<-EOT
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
  EOT
user_data_app = <<-EOT
#!/bin/bash
yum update -y
  EOT
}

resource "aws_launch_template" "web_tier" {
  name = "web_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  instance_type = "t2.micro"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_tier.id]
  }

  user_data = base64encode(local.user_data_web)
}

resource "aws_launch_template" "app_tier" {
  name = "app_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  instance_type = "t2.micro"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_tier.id]
  }

  user_data = base64encode(local.user_data_app)
}