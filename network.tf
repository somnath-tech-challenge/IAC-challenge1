##### Deploying Internet gateway for the public subnet #####

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "main"
  }
}

##### Deploying NAT gateway at the public subnet to be associated with private route #####

resource "aws_nat_gateway" "gateway" {
  count         = length(aws_subnet.public_subnet)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  depends_on    = [aws_internet_gateway.gateway]
  tags = {
    "Name" = "nat_gateway_${count.index + 1}"
  }
}

##### Elastic IP for NAT Gateway #####

resource "aws_eip" "nat_ip" {
  count      = length(aws_subnet.public_subnet)
  depends_on = [aws_internet_gateway.gateway]
  tags = {
    "Name" = "nat_ip_${count.index + 1}"
  }
}

##### Public Route table association #####

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route.id
}

##### Private Route table association #####

resource "aws_route_table" "private_route" {
  count  = length(aws_subnet.private_subnet)
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway[count.index].id
  }
  tags = {
    Name = "private_route_${count.index + 1}"
  }
}

resource "aws_route_table_association" "private-route" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route[count.index].id
}