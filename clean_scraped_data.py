import pandas as pd
import sys

# import the data
ulta = pd.read_csv(sys.argv[1])

# remove any rows without ingredients
ulta = ulta[ulta['ingredients'] != "None"]

# all ingredients to lowercase
ulta['ingredients'] = ulta['ingredients'].apply(lambda s: s.lower())

# remove duplicates
ulta = ulta.drop_duplicates(subset=['product_name','brand_name'])

# write to a fresh csv
ulta.to_csv(sys.argv[2])