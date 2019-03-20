#!/bin/bash
for region in `aws ec2 describe-regions --output text | cut -f3`
do
    echo -e "\nListing Instances in region:'$region'..."

    aws rds describe-db-instances --region $region   --query 'DBInstances[*].{ID:DBInstanceArn}' > $region-rds.json

    jq -c '.[]' $region-rds.json | while read i;
    do
       SNAP_ID=$(jq -r '.ID' <<< "$i");
       aws rds  add-tags-to-resource --resource-name $SNAP_ID --tags Key=cost,Value=test 
    done

done
