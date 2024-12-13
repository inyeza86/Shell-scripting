#!/bin/bash

# Ensure AWS CLI is installed and configured with appropriate credentials
if ! command -v aws &>/dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &>/dev/null; then
    echo "AWS CLI is not configured. Please run 'aws configure' to set it up."
    exit 1
fi

# Retrieve all running EC2 instances
echo "Fetching running EC2 instances..."

instances=$(aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=running \
    --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],InstanceType,State.Name]' \
    --output text)

# Check if there are any running instances
if [ -z "$instances" ]; then
    echo "No running EC2 instances found."
    exit 0
fi

# Print the results
echo -e "Instance ID\tInstance Name\tInstance Type\tState"
echo "$instances" | while read -r instance; do
    echo -e "$instance"
done
