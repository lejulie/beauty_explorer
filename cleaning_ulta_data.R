setwd("~/Desktop/NYCDSA/projects/web_scraping_project/exploring_beauty_products/data/")
ulta = read.csv("ulta format test.csv")
ulta$source = "ulta.com"

all_ingredients = ulta$ingredients    # extract just ingredients

clean_and_split = function(input){
  opt = strsplit(x = as.character(input), split = ",") # split by comma
  return(opt)                                                  
}

##### Get the list of unique ingredients

# clean spaces and funky chars
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


##### 

# Get stats on spec ingredients
x = grepl("Aloe", ulta$ingredients)
sum(x, na.rm=TRUE)

# look for all products with "Aloe" listed in the ingredients
Aloe = 
  ulta[grepl("Aloe", ulta$ingredients, fixed = TRUE),c('brand_name',
                                               'product_name', 
                                               'ingredients',
                                               'url'),]
