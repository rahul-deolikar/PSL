output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "security_group_id" {
  description = "ID of the ECS instances security group"
  value       = aws_security_group.ecs_instances.id
}

output "auto_scaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.ecs_asg.name
}

output "capacity_provider_name" {
  description = "Name of the ECS capacity provider"
  value       = aws_ecs_capacity_provider.main.name
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.ecs_instance.id
}