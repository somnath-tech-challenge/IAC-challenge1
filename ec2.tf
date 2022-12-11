#### Bootstrap data #####
locals {
  user_data_web = <<-EOT
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
  EOT
}

locals {
  user_data_app = <<-EOT
#!/bin/bash
yum update -y
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
  EOT
}

##### Aws AMI ID #####
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_caller_identity" "current" {}

#### EC2 IAM profile to enable AWS ssm connection #####

resource "aws_iam_instance_profile" "ec2_ssm_connection" {
  name = "ec2-ssm-connection"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "allow-ssm-session-ec2"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_ssm_policy" {
  name = "allow-ssm-session-ec2-policy"
  role = aws_iam_role.role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_2" {
role       = aws_iam_role.role.id
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
##### Launch Template for Web #####

resource "aws_launch_template" "web_tier" {
  name = "web_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_connection.name
  }

  instance_type = "t2.micro"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_tier.id]
  }

  user_data = base64encode(local.user_data_web)
}

#### Launch Template for App ####

resource "aws_launch_template" "app_tier" {
  name = "app_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }
  
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_connection.name
  }
  
  instance_type = "t2.micro"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app_tier.id]
  }

  user_data = base64encode(local.user_data_app)
}