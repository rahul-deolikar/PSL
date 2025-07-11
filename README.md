# ECS-EC2 Cluster POC with Terraform

This files contains a Proof of Concept (POC) for creating an AWS ECS cluster running on EC2 instances using Terraform Infrastructure as Code (IaC). The project includes automated deployment via GitHub Actions and stores Terraform state in S3.

## Architecture

The infrastructure creates:

- **VPC** with public subnets across 2 availability zones
![alt text](<vpc (2)-3.png>)

- **ECS Cluster** with EC2 capacity provider
![alt text](ecs-cluster-1.png)

- **Auto Scaling Group** for EC2 instances
![alt text](autoscalling.png)

- **Launch Template** with ECS-optimized AMI
![alt text](template-1.png)


- **Security Groups** with appropriate ingress/egress rules
![alt text](<sg (2)-1.png>)

- **IAM Roles** and policies for ECS instances

- **S3 Backend** for Terraform state storage
![alt text](tf.statefile-1.png)


## Prerequisites

- AWS CLI installed and configured (`aws configure`)

```
aws configure
```

AWS Access Key ID [****************2WZ6]: 

AWS Secret Access Key [****************Po7g]: 
Default region name [us-east-1]: 
Default output format [None]: 


- Terraform >= 1.0 installed
- Git installed-
- An AWS account with appropriate permissions
- A GitHub account (for Actions workflow)

### Required AWS Permissions

- EC2 VPC, instances, security groups, launch templates
- ECS clusters, capacity providers
- IAM (roles, policies, instance profiles)
- Auto Scaling
- S3 for state storage
- DynamoDB for state locking


### 1. Set Up S3 Backend (Manual Step)

First, create the S3 bucket for storing Terraform state:
![alt text](tf.statefile.png)

```bash
# Make the script executable
chmod +x scripts/setup-s3-backend.sh

# Run the setup script
./scripts/setup-s3-backend.sh
```

This script will:
- Create an S3 bucket with versioning enabled
- Enable server-side encryption
- Block public access
- Optionally create a DynamoDB table for state locking

### 2. Configure Variables

Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to match your requirements:

```hcl
aws_region      = "us-west-2"
project_name    = "my-ecs-poc"
cluster_name    = "my-ecs-cluster"
vpc_cidr        = "10.0.0.0/16"
instance_type   = "t3.medium"
min_size        = 1
max_size        = 5
desired_capacity = 2
```

### 3. Deploy Locally

Use the deployment script for local deployment:

```bash
# Make the script executable
chmod +x scripts/deploy.sh

# Deploy the infrastructure
./scripts/deploy.sh deploy
```

## Available Commands

The deployment script supports several commands:

```bash
./scripts/deploy.sh deploy      # Plan and apply (default)
./scripts/deploy.sh plan        # Run terraform plan only
./scripts/deploy.sh apply-plan  # Apply existing plan
./scripts/deploy.sh destroy     # Destroy all resources
./scripts/deploy.sh output      # Show terraform outputs
```

## GitHub Actions Workflow

The repository includes a GitHub Actions workflow 

- Triggers on pushes to `main` branch and pull requests
- Uses standard GitHub Actions:
  - `actions/checkout@v4` for code checkout
  - `hashicorp/setup-terraform@v3` for Terraform setup
  - `aws-actions/configure-aws-credentials@v4` for AWS authentication
  - `actions/github-script@v7` for PR comments
- Validates, plans, and applies Terraform configurations
- Comments on PRs with plan output

### Setting Up GitHub Actions

1. **Add AWS Credentials to GitHub Secrets**
   Go to your repository → Settings → Secrets and variables → Actions

2. **Create Production Environment**
   - Go to Settings → Environments
   - Create a "production" environment
   - Add protection rules if needed

3. **Push to Main Branch**
   The workflow will automatically trigger and deploy your infrastructure.

## Project Structure

```
.
├── main.tf                       
├── variables.tf                 
├── outputs.tf                   
├── user_data.sh                  
├── terraform.tfvars.example       
├── .gitignore                     
├── .github/
│   └── workflows/
│       └── terraform-deploy.yml   
├── scripts/
│   ├── setup-s3-backend.sh      
│   └── deploy.sh                 
└── README.md                    
```

### Instance Types

Modify the `instance_type` variable in `terraform.tfvars`:

```hcl
instance_type = "t3.large" 
```

### Scaling Configuration

Adjust the Auto Scaling Group parameters:

```hcl
min_size         = 2
max_size         = 10
desired_capacity = 4
```

### Networking

Change the VPC CIDR block:

```hcl
vpc_cidr = "172.16.0.0/16"
```

### Validation Commands

```bash
# Validate Terraform configuration
terraform validate

# Format Terraform files
terraform fmt

# Check for security issues (requires tfsec)
tfsec .

# Plan without applying
terraform plan
```

## Cleanup

To destroy all resources:

```bash
# Using the script
./scripts/deploy.sh destroy

# Or directly with Terraform
terraform destroy -auto-approve
```

## Implemention
Done 

---
s
