#!/bin/bash
for region in `aws ec2 describe-regions --output text | cut -f3`
do
    echo -e "\nListing Instances in region:'$region'..."

    aws elb describe-load-balancers --region $region   --query 'LoadBalancerDescriptions[*].{ID:LoadBalancerName}' > $region-elb.json

    jq -c '.[]' $region-elb.json | while read i;
    do
       SNAP_ID=$(jq -r '.ID' <<< "$i");
      aws elb add-tags --load-balancer-name $SNAP_ID --tags "Key=test,Value=val" 
    done

done
