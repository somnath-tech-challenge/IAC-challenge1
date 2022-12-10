resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr)
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_cidr)
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = var.private_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}