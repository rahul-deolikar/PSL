# Enhanced ECS Infrastructure for POC3
# This file extends the existing main.tf with additional resources for the complete CI/CD pipeline

# Additional ECR Repositories for POC3 applications
resource "aws_ecr_repository" "poc3_nodejs_react" {
  name                 = "poc3-nodejs-react"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "poc3-nodejs-react"
    Project     = "POC3"
    Application = "nodejs-react"
  }
}

resource "aws_ecr_repository" "poc3_python_fastapi" {
  name                 = "poc3-python-fastapi"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "poc3-python-fastapi"
    Project     = "POC3"
    Application = "python-fastapi"
  }
}

resource "aws_ecr_repository" "poc3_java_springboot" {
  name                 = "poc3-java-springboot"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "poc3-java-springboot"
    Project     = "POC3"
    Application = "java-springboot"
  }
}

resource "aws_ecr_repository" "poc3_dotnet_webapi" {
  name                 = "poc3-dotnet-webapi"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "poc3-dotnet-webapi"
    Project     = "POC3"
    Application = "dotnet-webapi"
  }
}

# ECR Lifecycle Policies
resource "aws_ecr_lifecycle_policy" "poc3_lifecycle_policy" {
  for_each = {
    nodejs-react    = aws_ecr_repository.poc3_nodejs_react.name
    python-fastapi  = aws_ecr_repository.poc3_python_fastapi.name
    java-springboot = aws_ecr_repository.poc3_java_springboot.name
    dotnet-webapi   = aws_ecr_repository.poc3_dotnet_webapi.name
  }

  repository = each.value

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Application Load Balancer
resource "aws_lb" "poc3_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name    = "${var.project_name}-alb"
    Project = "POC3"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for POC3 Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application specific ports
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-alb-sg"
    Project = "POC3"
  }
}

# Target Groups for each application
resource "aws_lb_target_group" "poc3_nodejs_react_tg" {
  name     = "poc3-nodejs-react-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "poc3-nodejs-react-tg"
    Project     = "POC3"
    Application = "nodejs-react"
  }
}

resource "aws_lb_target_group" "poc3_python_fastapi_tg" {
  name     = "poc3-python-fastapi-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "poc3-python-fastapi-tg"
    Project     = "POC3"
    Application = "python-fastapi"
  }
}

resource "aws_lb_target_group" "poc3_java_springboot_tg" {
  name     = "poc3-java-springboot-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/actuator/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "poc3-java-springboot-tg"
    Project     = "POC3"
    Application = "java-springboot"
  }
}

resource "aws_lb_target_group" "poc3_dotnet_webapi_tg" {
  name     = "poc3-dotnet-webapi-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "poc3-dotnet-webapi-tg"
    Project     = "POC3"
    Application = "dotnet-webapi"
  }
}

# ALB Listeners for each application
resource "aws_lb_listener" "poc3_nodejs_react_listener" {
  load_balancer_arn = aws_lb.poc3_alb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.poc3_nodejs_react_tg.arn
  }
}

resource "aws_lb_listener" "poc3_python_fastapi_listener" {
  load_balancer_arn = aws_lb.poc3_alb.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.poc3_python_fastapi_tg.arn
  }
}

resource "aws_lb_listener" "poc3_java_springboot_listener" {
  load_balancer_arn = aws_lb.poc3_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.poc3_java_springboot_tg.arn
  }
}

resource "aws_lb_listener" "poc3_dotnet_webapi_listener" {
  load_balancer_arn = aws_lb.poc3_alb.arn
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.poc3_dotnet_webapi_tg.arn
  }
}

# CloudWatch Log Groups for each application
resource "aws_cloudwatch_log_group" "poc3_nodejs_react_logs" {
  name              = "/ecs/poc3-nodejs-react"
  retention_in_days = 7

  tags = {
    Name        = "poc3-nodejs-react-logs"
    Project     = "POC3"
    Application = "nodejs-react"
  }
}

resource "aws_cloudwatch_log_group" "poc3_python_fastapi_logs" {
  name              = "/ecs/poc3-python-fastapi"
  retention_in_days = 7

  tags = {
    Name        = "poc3-python-fastapi-logs"
    Project     = "POC3"
    Application = "python-fastapi"
  }
}

resource "aws_cloudwatch_log_group" "poc3_java_springboot_logs" {
  name              = "/ecs/poc3-java-springboot"
  retention_in_days = 7

  tags = {
    Name        = "poc3-java-springboot-logs"
    Project     = "POC3"
    Application = "java-springboot"
  }
}

resource "aws_cloudwatch_log_group" "poc3_dotnet_webapi_logs" {
  name              = "/ecs/poc3-dotnet-webapi"
  retention_in_days = 7

  tags = {
    Name        = "poc3-dotnet-webapi-logs"
    Project     = "POC3"
    Application = "dotnet-webapi"
  }
}

# S3 Bucket for Artifacts
resource "aws_s3_bucket" "poc3_artifacts" {
  bucket = "${var.project_name}-artifacts-${random_string.bucket_suffix.result}"

  tags = {
    Name    = "poc3-artifacts"
    Project = "POC3"
  }
}

resource "aws_s3_bucket_versioning" "poc3_artifacts_versioning" {
  bucket = aws_s3_bucket.poc3_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "poc3_artifacts_encryption" {
  bucket = aws_s3_bucket.poc3_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "poc3_artifacts_pab" {
  bucket = aws_s3_bucket.poc3_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enhanced ECS Task Execution Role with additional permissions
resource "aws_iam_role_policy_attachment" "ecs_execution_role_ecr_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_logs_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Additional security group rules for ECS instances to allow ALB traffic
resource "aws_security_group_rule" "ecs_alb_ingress" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ecs_instances.id
  description              = "Allow ALB to reach ECS tasks on dynamic ports"
}