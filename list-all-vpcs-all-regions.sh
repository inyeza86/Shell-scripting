#!/bin/bash
# Dexcription: this script will list all vpcs across my aws account
# Date: 2024-12-13
# Modified: 2024-12-13
# Version: 1.0
# Usage: ./list_vpcs.sh
# List all VPCs
#aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,CidrBlock,IsDefault]' --output table
# List all VPCs with their names
#aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0],CidrBlock,IsDefault]' --output table

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

# Check if arguments are provided
if [ $# -gt 0 ]; then
    aws --version

    if [ $? -eq 0 ]; then
        REGIONS=$@
        for REGION in ${REGIONS}; do
            aws ec2 describe-vpcs --region ${REGION} \
                --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0],CidrBlock,IsDefault]' \
                --output table
        done
    else
        echo "AWS CLI is not working correctly. Please check your configuration."
    fi
else
    echo "Usage: $0 <region1> <region2> ..."
    echo "Please pass the regions as arguments."
fi
