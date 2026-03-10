# Bastion — small server in public subnet
# Only way to SSH into private EC2 instances
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_pair_name

  tags = { Name = "${var.project_name}-bastion" }
}

# Always use data source to get the latest Amazon Linux 2 AMI
# instead of hardcoding an AMI ID that changes by region
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

