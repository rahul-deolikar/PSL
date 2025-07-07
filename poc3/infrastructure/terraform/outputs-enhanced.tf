# Enhanced Outputs for POC3 Infrastructure

# ECR Repository URLs
output "ecr_repository_nodejs_react" {
  description = "ECR repository URL for Node.js/React application"
  value       = aws_ecr_repository.poc3_nodejs_react.repository_url
}

output "ecr_repository_python_fastapi" {
  description = "ECR repository URL for Python FastAPI application"
  value       = aws_ecr_repository.poc3_python_fastapi.repository_url
}

output "ecr_repository_java_springboot" {
  description = "ECR repository URL for Java Spring Boot application"
  value       = aws_ecr_repository.poc3_java_springboot.repository_url
}

output "ecr_repository_dotnet_webapi" {
  description = "ECR repository URL for .NET Core Web API application"
  value       = aws_ecr_repository.poc3_dotnet_webapi.repository_url
}

# Application Load Balancer
output "load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.poc3_alb.dns_name
}

output "load_balancer_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = aws_lb.poc3_alb.zone_id
}

output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.poc3_alb.arn
}

# Target Group ARNs
output "target_group_nodejs_react_arn" {
  description = "ARN of the Node.js/React target group"
  value       = aws_lb_target_group.poc3_nodejs_react_tg.arn
}

output "target_group_python_fastapi_arn" {
  description = "ARN of the Python FastAPI target group"
  value       = aws_lb_target_group.poc3_python_fastapi_tg.arn
}

output "target_group_java_springboot_arn" {
  description = "ARN of the Java Spring Boot target group"
  value       = aws_lb_target_group.poc3_java_springboot_tg.arn
}

output "target_group_dotnet_webapi_arn" {
  description = "ARN of the .NET Core Web API target group"
  value       = aws_lb_target_group.poc3_dotnet_webapi_tg.arn
}

# CloudWatch Log Groups
output "cloudwatch_log_group_nodejs_react" {
  description = "CloudWatch log group for Node.js/React application"
  value       = aws_cloudwatch_log_group.poc3_nodejs_react_logs.name
}

output "cloudwatch_log_group_python_fastapi" {
  description = "CloudWatch log group for Python FastAPI application"
  value       = aws_cloudwatch_log_group.poc3_python_fastapi_logs.name
}

output "cloudwatch_log_group_java_springboot" {
  description = "CloudWatch log group for Java Spring Boot application"
  value       = aws_cloudwatch_log_group.poc3_java_springboot_logs.name
}

output "cloudwatch_log_group_dotnet_webapi" {
  description = "CloudWatch log group for .NET Core Web API application"
  value       = aws_cloudwatch_log_group.poc3_dotnet_webapi_logs.name
}

# S3 Artifacts Bucket
output "artifacts_bucket_name" {
  description = "Name of the S3 bucket for storing build artifacts"
  value       = aws_s3_bucket.poc3_artifacts.bucket
}

output "artifacts_bucket_arn" {
  description = "ARN of the S3 bucket for storing build artifacts"
  value       = aws_s3_bucket.poc3_artifacts.arn
}

# Application Endpoints
output "application_endpoints" {
  description = "Application endpoints behind the load balancer"
  value = {
    nodejs_react    = "http://${aws_lb.poc3_alb.dns_name}:3000"
    python_fastapi  = "http://${aws_lb.poc3_alb.dns_name}:8000"
    java_springboot = "http://${aws_lb.poc3_alb.dns_name}:8080"
    dotnet_webapi   = "http://${aws_lb.poc3_alb.dns_name}:5000"
  }
}

# Health Check Endpoints
output "health_check_endpoints" {
  description = "Health check endpoints for all applications"
  value = {
    nodejs_react    = "http://${aws_lb.poc3_alb.dns_name}:3000/health"
    python_fastapi  = "http://${aws_lb.poc3_alb.dns_name}:8000/health"
    java_springboot = "http://${aws_lb.poc3_alb.dns_name}:8080/actuator/health"
    dotnet_webapi   = "http://${aws_lb.poc3_alb.dns_name}:5000/health"
  }
}

# Documentation Endpoints
output "documentation_endpoints" {
  description = "API documentation endpoints"
  value = {
    nodejs_react    = "http://${aws_lb.poc3_alb.dns_name}:3000/api/info"
    python_fastapi  = "http://${aws_lb.poc3_alb.dns_name}:8000/docs"
    java_springboot = "http://${aws_lb.poc3_alb.dns_name}:8080/actuator"
    dotnet_webapi   = "http://${aws_lb.poc3_alb.dns_name}:5000/swagger"
  }
}

# Deployment Information
output "deployment_info" {
  description = "Key information for CI/CD pipeline deployment"
  value = {
    aws_region           = var.aws_region
    cluster_name         = aws_ecs_cluster.main.name
    cluster_arn          = aws_ecs_cluster.main.arn
    vpc_id               = aws_vpc.main.id
    private_subnet_ids   = aws_subnet.public[*].id  # Using public subnets for this POC
    security_group_id    = aws_security_group.ecs_instances.id
    alb_security_group_id = aws_security_group.alb_sg.id
    execution_role_arn   = aws_iam_role.ecs_instance_role.arn
    capacity_provider    = aws_ecs_capacity_provider.main.name
  }
}

# Summary output for easy reference
output "poc3_summary" {
  description = "Summary of POC3 deployment"
  value = {
    message = "POC3 Complete CI/CD Pipeline deployed successfully!"
    applications = [
      "Node.js/React (Port 3000)",
      "Python FastAPI (Port 8000)", 
      "Java Spring Boot (Port 8080)",
      ".NET Core Web API (Port 5000)"
    ]
    access_url = "http://${aws_lb.poc3_alb.dns_name}"
    next_steps = [
      "Configure TeamCity CI pipeline",
      "Set up security scanning tools",
      "Configure Octopus Deploy",
      "Deploy applications to ECS"
    ]
  }
}