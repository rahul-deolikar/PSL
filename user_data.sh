#!/bin/bash

# Update the system
yum update -y

# Configure ECS cluster
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config

# Install CloudWatch agent (optional)
yum install -y amazon-cloudwatch-agent

# Start and enable ECS agent
systemctl start ecs
systemctl enable ecs

# Install additional packages if needed
yum install -y htop

# Configure log rotation for container logs
cat > /etc/logrotate.d/docker-container << 'EOF'
/var/log/docker-container-*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0644 root root
}
EOF