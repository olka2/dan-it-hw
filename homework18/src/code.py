import os
import boto3

TAG_KEY   = os.getenv("TAG_KEY", "AutoStop")
TAG_VALUE = os.getenv("TAG_VALUE", "true")
EC2_REGION = os.getenv("EC2_REGION") or os.getenv("AWS_REGION") or os.getenv("AWS_DEFAULT_REGION")

ec2 = boto3.client("ec2", region_name=EC2_REGION)

def get_running_instances_by_tag(tag_key, tag_value):
    paginator = ec2.get_paginator("describe_instances")
    filters = [
        {"Name": f"tag:{tag_key}", "Values": [tag_value]},
        {"Name": "instance-state-name", "Values": ["running"]}
    ]
    ids = []
    for page in paginator.paginate(Filters=filters):
        for r in page.get("Reservations", []):
            for i in r.get("Instances", []):
                ids.append(i["InstanceId"])
    return ids

def stop_instances(instance_ids):
    for i in range(0, len(instance_ids), 100):
        ec2.stop_instances(InstanceIds=instance_ids[i:i+100])

def lambda_handler(event, context):
    print(f"Region={EC2_REGION}, filter={TAG_KEY}={TAG_VALUE}")
    instances = get_running_instances_by_tag(TAG_KEY, TAG_VALUE)
    print(f"Found {len(instances)} running: {instances}")
    if instances:
        stop_instances(instances)
        print("Stop initiated")
    else:
        print("Nothing to stop")
    return {"stopped": instances, "region": EC2_REGION}
