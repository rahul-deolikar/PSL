terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket-name"
    key            = "ecs-ec2-cluster/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
