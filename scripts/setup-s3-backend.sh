#!/bin/bash

# Script to set up S3 bucket for Terraform state storage
# This script should be run manually before running Terraform

set -e

# Configuration
BUCKET_NAME="terraform-state-ecs-poc-bucket"
REGION="us-west-2"
DYNAMODB_TABLE="terraform-state-locks"

echo "Setting up S3 backend for Terraform state..."

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if AWS credentials are configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: AWS credentials are not configured. Please run 'aws configure' first."
    exit 1
fi

# Create S3 bucket
echo "Creating S3 bucket: $BUCKET_NAME"
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Bucket $BUCKET_NAME already exists"
else
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"
    
    echo "Bucket created successfully"
fi

# Enable versioning
echo "Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

# Enable server-side encryption
echo "Enabling server-side encryption..."
aws s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

# Block public access
echo "Blocking public access..."
aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Optional: Create DynamoDB table for state locking
read -p "Do you want to create a DynamoDB table for state locking? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Creating DynamoDB table: $DYNAMODB_TABLE"
    if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" &> /dev/null; then
        echo "DynamoDB table $DYNAMODB_TABLE already exists"
    else
        aws dynamodb create-table \
            --table-name "$DYNAMODB_TABLE" \
            --attribute-definitions \
                AttributeName=LockID,AttributeType=S \
            --key-schema \
                AttributeName=LockID,KeyType=HASH \
            --provisioned-throughput \
                ReadCapacityUnits=5,WriteCapacityUnits=5
        
        echo "DynamoDB table created successfully"
        echo "Note: Update main.tf to uncomment the dynamodb_table line in the backend configuration"
    fi
fi

echo ""
echo "S3 backend setup completed!"
echo "Bucket name: $BUCKET_NAME"
echo "Region: $REGION"
echo ""
echo "Make sure to update the bucket name in main.tf if you used a different name."
echo "You can now run 'terraform init' to initialize the backend."