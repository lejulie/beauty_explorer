import pandas as pd
import sys
import re

ulta = pd.read_csv(sys.argv[1])

##### Get the list of unique ingredients #####

# Extract just ingredients as strings
ingredients = ulta.ingredients
ingredients = [str(s) for s in ingredients]

# Remove extraneous phrases and characters
ingredients_cleaned = list(map(lambda s: s.replace(':','').replace('!','').replace('may contain','')
	.replace('peut contenir','').replace('\n','').replace('\r','').replace('*','').replace('.','')\
	.replace('"','').replace('¿','').replace('[','').replace(']','').replace('()','')\
	.replace('&','').replace('(+/-)','').replace('[+/-]','').replace('+/-','')\
	.replace("(/)","").replace("//",""), ingredients))


# split and flatten
ingredients_cleaned = list(map(lambda s: s.split(','), ingredients_cleaned))
ingredients_cleaned = [item for sublist in ingredients_cleaned for item in sublist]

# trim whitespace
ingredients_cleaned = list(map(lambda s: s.strip(), ingredients_cleaned))

# remove leading / training slashes
pattern = "^\s?\/\s?"
ingredients_cleaned = list(map(lambda s: re.sub(pattern, "",s).strip(), ingredients_cleaned))

pattern = "\s?\/\s?$"
ingredients_cleaned = list(map(lambda s: re.sub(pattern, "",s).strip(), ingredients_cleaned))

# to dataframe, dedupe, sort, and to csv
dic = {"ingredients":ingredients_cleaned}
df = pd.DataFrame.from_dict(dic)
df = df.drop_duplicates()
df = df.sort_values(by="ingredients")
df.to_csv(sys.argv[2])



# remove "aqua / eau"
# pattern = "\s?(\/|\(|\\|,)?\s?(eau de mer|eau|aqua)\s?,?\)?\/?"
# ingredients_cleaned = list(map(lambda s: re.sub(pattern, "",s), ingredients_cleaned))