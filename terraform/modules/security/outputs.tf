output "alb_sg_id"     { value = aws_security_group.alb.id }
output "ec2_sg_id"     { value = aws_security_group.ec2.id }
output "bastion_sg_id" { value = aws_security_group.bastion.id }
output "rds_sg_id"     { value = aws_security_group.rds.id }
output "ec2_instance_profile_name" { value = aws_iam_instance_profile.ec2.name }
output "github_actions_role_arn" { value = aws_iam_role.github_actions.arn }