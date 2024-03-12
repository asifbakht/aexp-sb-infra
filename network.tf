# get available AZs
data "aws_availability_zones" "available_azs" {

}

# define VPC
resource "aws_vpc" "main_network" {
  cidr_block = "95.10.0.0/16"
}

# define ${var.az_count} private subnets (one for each AZ)
resource "aws_subnet" "private_subnet" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main_network.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available_azs.names[count.index]
  vpc_id                  = aws_vpc.main_network.id
  map_public_ip_on_launch = true
}

# define ${var.az_count} public subnets (one for each AZ)
resource "aws_subnet" "public_subnet" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main_network.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available_azs.names[count.index]
  vpc_id                  = aws_vpc.main_network.id
  map_public_ip_on_launch = true
}

# define IGW
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_network.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main_network.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# define NAT gateway for each private subnet
resource "aws_eip" "nat_gateway_eip" {
  count      = var.az_count
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  allocation_id = element(aws_eip.nat_gateway_eip.*.id, count.index)
}

# define route table for each private subnet
resource "aws_route_table" "private_route_table" {
  count  = var.az_count
  vpc_id = aws_vpc.main_network.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }
}

# associate route tables with private subnets
resource "aws_route_table_association" "private_route_table_association" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = flatten([aws_subnet.private_subnet.*.id])
}
