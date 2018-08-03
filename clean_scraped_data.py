import pandas as pd
import sys

# import the data
ulta = pd.read_csv(sys.argv[1])

# remove any rows without ingredients
ulta = ulta[ulta['ingredients'] != "None"]

# all ingredients to lowercase
ulta['ingredients'] = ulta['ingredients'].apply(lambda s: str(s).lower())

# remove duplicates
ulta = ulta.drop_duplicates(subset=['product_name','brand_name'])

# remove anything without ingredients, brand name, product name, or URL
ulta = ulta.dropna(subset=['brand_name', 'product_name', 'ingredients','url'])

# reformat categories
ulta['categories'] = ulta['categories'].apply(lambda s: s.replace(","," > "))

# convert stars
ulta['review_avg_rating'] = ulta['review_avg_rating'].apply(lambda s: str(s)[:3] if str(s) != "nan" else "-")

# write to a fresh csv
ulta.to_csv(sys.argv[2])