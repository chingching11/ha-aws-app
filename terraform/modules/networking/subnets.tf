# Public subnets — ALB, Bastion, NAT Gateway live here
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-public-${count.index + 1}" }
}

# Private subnets — EC2 app servers live here, no direct internet access
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = var.azs[count.index]
  tags = { Name = "${var.project_name}-private-${count.index + 1}" }
}

# Database subnets — RDS only, most isolated layer
resource "aws_subnet" "database" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 20}.0/24"
  availability_zone = var.azs[count.index]
  tags = { Name = "${var.project_name}-db-${count.index + 1}" }
}