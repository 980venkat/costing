#!/bin/bash
for region in `aws ec2 describe-regions --output text | cut -f3`
do
    echo -e "\nListing Instances in region:'$region'..."

    aws ec2 describe-snapshots --region $region   --query 'Snapshots[*].{ID:SnapshotId}' > $region-snp.json

    jq -c '.[]' $region-snp.json | while read i;
    do
       SNAP_ID=$(jq -r '.ID' <<< "$i");
       aws ec2 create-tags --resources $SNAP_ID --tags Key=,Value=
    done

done
