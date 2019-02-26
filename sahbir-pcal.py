import pandas as pd
import awspricing

ec2_offer = awspricing.offer('AmazonEC2')

df=pd.read_csv("Shabbir-jnpr-it-dev_OD_Running_HRS_3months.csv")

for index, row in df.iterrows():

    print(index,'--',row['Instance Type'].strip(), row['Region'].strip(), row['Platform'].strip())
    try:
      r3 = ec2_offer.reserved_hourly(
           row['Instance Type'].strip(),
           operating_system=row['Platform'].strip(),
           lease_contract_length='3yr',
           purchase_option='No Upfront',
           region= row['Region'].strip()
           )

    except :
      r3=0
      print('Invalid -- ',row['Instance Type'], row['Region'], row['Platform'])

    try:
      r1 = ec2_offer.reserved_hourly(
           row['Instance Type'].strip(),
           operating_system=row['Platform'].strip(),
           lease_contract_length='3yr',
           purchase_option='All Upfront',
           region= row['Region'].strip()
           )

    except :
      r1=0
      print('Invalid -- ',row['Instance Type'].strip(), row['Region'].strip(), row['Platform'].strip())


    print(index,'--',row['Instance Type'].strip(), row['Region'].strip(), row['Platform'].strip(),'--',r3,'--',r1,'--')

    df.set_value(index, '3 YR RI - NUF/hr', r3)
    df.set_value(index, '3 YR RI AUPF/Hr',  r1)

df.to_csv("Shabbir-jnpr-id-dev-output.csv", index=False)
