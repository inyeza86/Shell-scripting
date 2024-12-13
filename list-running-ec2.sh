# list all the running ec2 instances on my account
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Tags[0].Value]' --output text | awk '{print $1,$2,$3,$4}' | column -t
