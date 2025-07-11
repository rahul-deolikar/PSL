# ECS-EC2 Cluster POC with Terraform

This files contains a Proof of Concept (POC) for creating an AWS ECS cluster running on EC2 instances using Terraform Infrastructure as Code (IaC). The project includes automated deployment via GitHub Actions and stores Terraform state in S3.

## Architecture

The infrastructure creates:

- **VPC** with public subnets across 2 availability zones
"C:\Users\swati\OneDrive\Pictures\Screenshots\poc-1\vpc (2).png"
- **ECS Cluster** with EC2 capacity provider
![alt text](<vpc (2)-1.png>)
- **Auto Scaling Group** for EC2 instances
![alt text](auto-scalling.png)
- **Launch Template** with ECS-optimized AMI
![alt text](template.png)
- **Security Groups** with appropriate ingress/egress rules
![alt text](<sg (2).png>)
- **IAM Roles** and policies for ECS instances
![alt text](image.png)
- **S3 Backend** for Terraform state storage
![alt text](s3-bucket.png)


## Prerequisites

Before you begin, ensure you have:


- AWS CLI installed and configured (`aws configure`)
'''
$ aws configure
AWS Access Key ID [****************2WZ6]: 
AWS Secret Access Key [****************Po7g]: 
Default region name [us-east-1]: 
Default output format [None]: 
'''

- Terraform >= 1.0 installed
- Git installed-
- An AWS account with appropriate permissions
- A GitHub account (for Actions workflow)

### Required AWS Permissions

Your AWS user/role needs permissions for:
- EC2 (VPC, instances, security groups, launch templates)
- ECS (clusters, capacity providers)
- IAM (roles, policies, instance profiles)
- Auto Scaling
- S3 (for state storage)
- DynamoDB (optional, for state locking)

## Quick Start

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

The repository includes a GitHub Actions workflow (`.github/workflows/terraform-deploy.yml`) that:

- Triggers on pushes to `main` branch and pull requests
- Uses standard GitHub Actions:
  - `actions/checkout@v4` for code checkout
  - `hashicorp/setup-terraform@v3` for Terraform setup
  - `aws-actions/configure-aws-credentials@v4` for AWS authentication
  - `actions/github-script@v7` for PR comments
- Validates, plans, and applies Terraform configurations
- Comments on PRs with plan output

### Setting Up GitHub Actions

1. **Add AWS Credentials to GitHub Secrets:**
   Go to your repository → Settings → Secrets and variables → Actions

   Add these secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

2. **Create Production Environment (Optional):**
   - Go to Settings → Environments
   - Create a "production" environment
   - Add protection rules if needed

3. **Push to Main Branch:**
   The workflow will automatically trigger and deploy your infrastructure.

## Project Structure

```
.
├── main.tf                        # Main Terraform configuration
├── variables.tf                   # Variable definitions
├── outputs.tf                     # Output definitions
├── user_data.sh                   # EC2 user data script
├── terraform.tfvars.example       # Example variables file
├── .gitignore                     # Git ignore patterns
├── .github/
│   └── workflows/
│       └── terraform-deploy.yml   # GitHub Actions workflow
├── scripts/
│   ├── setup-s3-backend.sh       # S3 backend setup script
│   └── deploy.sh                 # Local deployment script
└── README.md                      # This file
```

## Terraform Resources Created

| Resource Type | Description |
|---------------|-------------|
| `aws_vpc` | Virtual Private Cloud |
| `aws_subnet` | Public subnets (2 AZs) |
| `aws_internet_gateway` | Internet connectivity |
| `aws_route_table` | Routing configuration |
| `aws_security_group` | Network security rules |
| `aws_iam_role` | IAM role for ECS instances |
| `aws_iam_instance_profile` | Instance profile |
| `aws_launch_template` | EC2 launch configuration |
| `aws_autoscaling_group` | Auto scaling group |
| `aws_ecs_cluster` | ECS cluster |
| `aws_ecs_capacity_provider` | Capacity provider |

## Outputs

After successful deployment, Terraform provides these outputs:

- `cluster_name`: Name of the ECS cluster
- `cluster_arn`: ARN of the ECS cluster
- `vpc_id`: VPC identifier
- `public_subnet_ids`: List of public subnet IDs
- `security_group_id`: Security group ID
- `auto_scaling_group_name`: ASG name
- `capacity_provider_name`: Capacity provider name
- `launch_template_id`: Launch template ID

## Customization

### Instance Types

Modify the `instance_type` variable in `terraform.tfvars`:

```hcl
instance_type = "t3.large"  # or t3.small, m5.large, etc.
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

## Troubleshooting

### Common Issues

1. **S3 Bucket Already Exists**
   - Update the bucket name in `main.tf` (line 13)
   - Or use the existing bucket if you own it

2. **AWS Credentials Not Found**
   ```bash
   aws configure
   # or export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
   ```

3. **Terraform State Lock**
   ```bash
   terraform force-unlock <LOCK_ID>
   ```

4. **GitHub Actions Failing**
   - Check AWS credentials in GitHub Secrets
   - Ensure the S3 bucket exists and is accessible
   - Verify IAM permissions

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

## Security Considerations

- EC2 instances are in public subnets but security groups restrict access
- SSH access is limited to VPC CIDR range
- ECS instances use IAM roles instead of access keys
- S3 state bucket has encryption and versioning enabled
- GitHub Actions uses OIDC or access keys (store in secrets)

## Cleanup

To destroy all resources:

```bash
# Using the script
./scripts/deploy.sh destroy

# Or directly with Terraform
terraform destroy -auto-approve
```

**Note:** This will not delete the S3 state bucket. Delete it manually if needed.

## Implemention
Done 

---
