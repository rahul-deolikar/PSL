# ECS-EC2 Cluster POC with Terraform

This repository contains a Proof of Concept (POC) for creating an AWS ECS cluster running on EC2 instances using Terraform Infrastructure as Code (IaC). The project includes automated deployment via GitHub Actions and stores Terraform state in S3.

## 🏗️ Architecture (with Screenshots)

The infrastructure creates:

- **VPC** with public subnets across 2 availability zones
- **ECS Cluster** with EC2 capacity provider
- **Auto Scaling Group** for EC2 instances
- **Launch Template** with ECS-optimized AMI
- **Security Groups** with appropriate ingress/egress rules
- **IAM Roles** and policies for ECS instances
- **S3 Backend** for Terraform state storage

### 📸 Architecture Snapshots

#### Auto Scaling Group
![Auto Scaling Group](autoscalling.png)
This screenshot shows the Auto Scaling Group created for ECS instances. It manages the desired number of EC2 instances based on the specified capacity and scaling policies.

#### EC2 Instances
![EC2 Instances](EC2-Instances.png)
These are the EC2 instances launched by the Auto Scaling Group. They are registered with the ECS cluster and are in the `running` state.

#### ECS Cluster
![ECS Cluster](ecs-cluster.png)
The ECS cluster created via Terraform. It is currently empty and ready to run tasks or services on the EC2 instances.

#### Internet Gateway
![Internet Gateway](ig (2).png)
This is the Internet Gateway attached to the custom VPC to allow internet access to public subnets and instances.

#### Network ACL
![Network ACL](nacl (2).png)
Network ACLs control inbound and outbound traffic at the subnet level. This shows the ACL associated with the ECS VPC.

#### Route Table
![Route Table](rt (2).png)
The route table configured for the public subnets. It contains a route to the internet through the Internet Gateway.

#### S3 Bucket
![S3 Bucket](s3-bucket (2).png)
This S3 bucket is used to store the Terraform state file. Versioning is enabled for rollback and collaboration.

#### Security Group
![Security Group](sg (2).png)
This security group allows traffic to the ECS instances on ports such as 22 (SSH) and 80/443 (HTTP/HTTPS), as configured.

#### Volumes
![Volumes](volume (2).png)
These EBS volumes are attached to the running EC2 instances as their root disks. They are created automatically with each instance.

## 📋 Prerequisites

Before you begin, ensure you have:

- AWS CLI installed and configured (`aws configure`)
- Terraform >= 1.0 installed
- Git installed
- An AWS account with appropriate permissions
- A GitHub account (for Actions workflow)

... *(rest of the original README content continues here)*

