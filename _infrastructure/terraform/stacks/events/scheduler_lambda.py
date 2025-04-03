import boto3
import os

def lambda_handler(event, context):
    ec2_id = os.environ['EC2_INSTANCE_ID']
    rds_identifier = os.environ['RDS_INSTANCE_IDENTIFIER']
    action = event.get("action", "stop")  # default to stop

    ec2 = boto3.client('ec2')
    rds = boto3.client('rds')

    if action == "start":
        print(f"Starting EC2 instance {ec2_id}")
        ec2.start_instances(InstanceIds=[ec2_id])
        
        if os.getenv("use_rds") == "true":
            print(f"Starting RDS instance {rds_identifier}")
            rds.start_db_instance(DBInstanceIdentifier=rds_identifier)

        return {"status": "started resources"}

    else:
        print(f"Stopping EC2 instance {ec2_id}")
        ec2.stop_instances(InstanceIds=[ec2_id])
        
        if os.getenv("use_rds") == "true":
            print(f"Stopping RDS instance {rds_identifier}")
            rds.stop_db_instance(DBInstanceIdentifier=rds_identifier)

        return {"status": "stopped resources"}
