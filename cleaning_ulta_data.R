library(dplyr)

#setwd("~/Desktop/NYCDSA/projects/web_scraping_project/
#exploring_beauty_products/data/")

ulta = read.csv("ulta_skincare.csv")
ulta$source = "www.ulta.com"
dim(ulta)

##### Clean the scraped data #####

## Remove anything without ingredients

ulta = filter(ulta, ingredients != "None")
dim(ulta)

## Remove duplicates (prods with same name and ingredients)

# What are the dupes?
dupes = ulta %>%
  group_by(., brand_name, product_name, ingredients) %>%
  summarise(., cnt = n()) %>%
  filter(., cnt >1)

# confirm what's causing them by looking at a few examples
# we see that these are the same products, just in different sizes and 
# sometimes with slightly different descriptions; since this 
# investigation is around ingredients, we're good to consolidate them
#
# filter(ulta, product_name == "Blue Ridge Wildflower Hand Cream") %>% 
#   select(-ingredients)
# filter(ulta, product_name == "Online Only Anti-Blemish Facial Wash") %>% 
#   select(-ingredients)
# filter(ulta, product_name == "Deep Cleansing Pore Strips") %>% 
#   select(-ingredients)

# remove duplicates
to_remove = match(dupes$product_name, ulta$product_name)
ulta = ulta[-to_remove,]

# what about ones with different ingredients?
by_prod = ulta %>% 
  group_by(product_name, brand_name) %>% 
  summarise(., cnt = n()) %>% 
  arrange(., desc(cnt))
dupes2 = filter(by_prod, cnt > 1)

# <50 rows (<0.5% of sample)
# upon visual inspection they tend to be pretty close, keep the 1st
# occurence of each
#opt = filter(ulta, product_name %in% dupes2$product_name)
# write.csv(opt, "possible dupes.csv")

to_remove2 = match(dupes2$product_name, ulta$product_name)
ulta = ulta[-to_remove2,]

# write the cleaned data to a fresh csv
write.csv(ulta, "ulta_cleaned.csv")



##### Get the list of unique ingredients #####

# Extract just ingredients
all_ingredients = ulta$ingredients 

# clean spaces and funky chars
clean_and_split = function(input){
  opt = strsplit(x = as.character(input), split = ",") # split by comma
  return(opt)                                                  
}

all_ingredients = lapply(all_ingredients, clean_and_split)
all_ingredients[1:3]

# flatten into a list of unique ingredients
ingredient_list = do.call(c, unlist(all_ingredients, recursive = FALSE))
ingredient_list = sort(unique(ingredient_list))
ingredient_list = gsub(x = ingredient_list, pattern = '\n', 
                       replacement = "", fixed = TRUE)
ingredient_list = gsub(x = ingredient_list, pattern = '.', 
                       replacement = "", fixed = TRUE)
ingredient_list = trimws(ingredient_list, which = "left")

il = unique(ingredient_list)
il = sort(il)
il[1:20]
class(ingredient_list)

# Get stats on spec ingredients
x = grepl("Aloe", ulta$ingredients)
sum(x, na.rm=TRUE)

# look for all products with "Aloe" listed in the ingredients
Aloe = 
  ulta[grepl("Aloe", ulta$ingredients, fixed = TRUE),c('brand_name',
                                               'product_name', 
                                               'ingredients',
                                               'url'),]
