data "aws_availability_zones" "available" {}

resource "aws_vpc" "mainvpc" {
  cidr_block = var.main_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "mainvpc"
  }
}
