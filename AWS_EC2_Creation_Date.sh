#!/bin/bash
for region in `aws ec2 describe-regions --output text | cut -f3`
do
     echo -e "\nListing Instances in region:'$region'..."

    aws ec2 describe-instances --region $region   --query 'Reservations[*].Instances[*].{ID:InstanceId,LaunchTime:LaunchTime,Root:RootDeviceName,Type:InstanceType,Platform:Platform}' > $region-j.json

    jq -c '.[][]' $region-j.json | while read i;
    do
       rootv=$(jq -r '.Root' <<< "$i");
       iid=$(jq -r '.ID' <<< "$i");
       ltim=$(jq -r '.LaunchTime' <<< "$i");
       typei=$(jq -r '.Type' <<< "$i");
       Platform=$(jq -r '.Platform' <<< "$i");
      atttime=$(aws ec2 describe-volumes --region $region --filters Name=attachment.instance-id,Values=$iid Name=attachment.device,Values=$rootv --query "Volumes[*].{VID:VolumeId,AttachTime:Attachments[0].AttachTime}" | jq .[0].AttachTime)
      echo "$iid,$typei,$ltim,$atttime,$region,$Platform"
      echo "$iid,$typei,$ltim,$atttime,$region,$Platform" >> "$region"-c.csv
    done

done
