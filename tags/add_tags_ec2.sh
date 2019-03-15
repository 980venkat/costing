#!/bin/bash
for region in `aws ec2 describe-regions --output text | cut -f3`
do
    echo -e "\nListing Instances in region:'$region'..."

    aws ec2 describe-instances --region $region   --query 'Reservations[*].Instances[*].{ID:InstanceId}' > $region-j.json

    jq -c '.[][]' $region-j.json | while read i;
    do
       iid=$(jq -r '.ID' <<< "$i");
       aws ec2 create-tags --resources $iid --tags Key=cost,Value=test
    done

done
