import pandas as pd
import sys
import re

# import the data
ulta = pd.read_csv(sys.argv[1])

# remove any rows without ingredients
ulta = ulta[ulta['ingredients'] != "None"]

# remove duplicates
ulta = ulta.drop_duplicates(subset=['product_name','brand_name'])

# remove anything without ingredients, brand name, product name, or URL
ulta = ulta.dropna(subset=['brand_name', 'product_name', 'ingredients','url'])

# reformat categories
ulta['categories'] = ulta['categories'].apply(lambda s: s.replace(","," > ").replace("Home > ",""))

# split into top level category and subcategory
pattern1 = " > [a-zA-z&' >-]*"
pattern2 = "[a-zA-z &' -]* > "
ulta['top_level_category'] = ulta['categories'].apply(lambda s: re.sub(pattern1,"",s).strip())
ulta['secondary_category'] = ulta['categories'].apply(lambda s: re.sub(pattern2,"",s,1).strip())

# convert stars
ulta['review_avg_rating'] = ulta['review_avg_rating'].apply(lambda s: s[:3] if str(s) != "nan" else "-")

# replace ratings of zero with "-"
ulta['review_avg_rating'] = ulta['review_avg_rating'].apply(lambda s: '-' if s == 0 else s)

# write to a fresh csv
ulta.to_csv(sys.argv[2])