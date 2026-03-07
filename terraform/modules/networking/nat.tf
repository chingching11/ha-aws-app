# Elastic IP — fixed public IP address attached to NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
  tags       = { Name = "${var.project_name}-nat-eip" }
}

# NAT Gateway — sits in public subnet, gives private EC2s
# outbound-only internet access for pulling Docker images
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.main]
  tags          = { Name = "${var.project_name}-nat" }
}