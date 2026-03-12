resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name = var.key_pair_name

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ec2_sg_id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    aws_region  = var.aws_region
    ecr_repo    = var.ecr_repo_url
    secret_name = var.db_secret_name
    db_host     = var.db_host
  }))

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${var.project_name}-app" }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-asg"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.main.arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app"
    propagate_at_launch = true
  }
}

