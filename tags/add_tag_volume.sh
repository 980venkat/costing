#!/bin/bash
for region in `aws ec2 describe-regions --output text | cut -f3`
do
    echo -e "\nListing Instances in region:'$region'..."

    aws ec2 describe-volumes --region $region   --query 'Volumes[*].{ID:VolumeId}' > $region-vol.json

    jq -c '.[][]' $region-vol.json | while read i;
    do
       vid=$(jq -r '.ID' <<< "$i");
       aws ec2 create-tags --resources $vid --tags Key=cost,Value=test
    done

done
