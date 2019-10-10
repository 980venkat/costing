import pandas as pd
import awspricing

ec2_offer = awspricing.offer('AmazonEC2')

df=pd.read_csv("dev-test.csv", index_col="ID")

for index, row in df.iterrows():

    print(index,'--',row['TYPE'], row['REGION'], row['Platform'])
    try:
      r3 = ec2_offer.reserved_hourly(
           row['TYPE'],
           operating_system=row['Platform'],
           lease_contract_length='3yr',
           purchase_option='No Upfront',
           region= row['REGION']
           )
    except :
      r3=-1
      print('Invalid -- ',row['TYPE'], row['REGION'], row['Platform'])

    print(index,'--',row['TYPE'], row['REGION'], row['Platform'],'--',r3)
      #print row.items()
    df.set_value(index, '3Y-RI-NUF', r3)

df.to_csv("out.csv", index=False)
