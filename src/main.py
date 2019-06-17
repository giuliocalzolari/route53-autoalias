#!/usr/bin/env python3

#
# Route53 auto alias
# xmanning - 2017
#

from __future__ import print_function
import boto3
from datetime import datetime
route53_client = boto3.client("route53")

def get_tag(obj):
    tmp = {}
    if obj == None:
        return tmp
    elif "Tags" in obj:
        tags = obj["Tags"]
    elif isinstance(obj, (list)):
        tags = obj
    else:
        return tmp

    for t in tags:
        tmp[t["Key"]] = t["Value"]
    return tmp


def get_route53_zone_id(domain, public=False):
    zones = route53_client.list_hosted_zones_by_name(DNSName=domain)
    if not zones or len(zones["HostedZones"]) == 0:
        raise Exception("Could not find DNS")
    for zone in zones["HostedZones"]:
        if zone["Config"]["PrivateZone"] == public:
            return zone["Id"].replace("/hostedzone/","")

    raise Exception("Zone not found")


def set_cname_record(zone_id, source, target):
    print("update zoneid: {} CNAME {} to: {}".format(zone_id, source, target))
    route53_client.change_resource_record_sets(
    HostedZoneId=zone_id,
    ChangeBatch= {
                    "Comment": "route53-autoalias",
                    "Changes": [
                        {
                            "Action": "UPSERT",
                            "ResourceRecordSet": {
                                "Name": source,
                                "Type": "CNAME",
                                "TTL": 60,
                                "ResourceRecords": [{"Value": target}]
                        }
                    }]
    })


def delete_record(zone_id, record):
    print("delete CNAME {} in zone: {}".format(record, zone_id))
    target = get_record(zone_id, record)
    route53_client.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            "Changes": [
                {
                    "Action": "DELETE",
                    "ResourceRecordSet": {
                        "Name": record,
                        "Type": "CNAME",
                        "TTL": 60,
                        "ResourceRecords": [{"Value": target}]
                    }
                }
            ]
        }
    )

def get_record(zone_id, record):
    response = route53_client.list_resource_record_sets(
        HostedZoneId=zone_id,
        StartRecordName=record,
        StartRecordType="CNAME",
    )
    return response["ResourceRecordSets"][0]["ResourceRecords"][0]["Value"]

def lambda_handler(event, context):

    # gets the instance id 
    instance_id = event["detail"]["instance-id"]

    ec2 = boto3.resource("ec2")
    i = ec2.Instance(instance_id)
    inst_tags = get_tag(i.tags)
    cname = inst_tags.get("CNAME", None)
    if cname:
        _, ext = cname.split(".",1)
        zone_id = get_route53_zone_id(ext)

        if event["detail"]["state"] == "running":
            set_cname_record(zone_id, cname, i.public_dns_name)
        elif event["detail"]["state"] == "terminated":
            delete_record(zone_id, cname)



if __name__ == "__main__":
    lambda_handler({"detail": {"instance-id": "i-054cc0216ee3c5853", "state": "running"}},{})
