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