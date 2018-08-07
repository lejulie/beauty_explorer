# Create a csv with counts of products in each family by brand
# Note that this version should remove non-alphaneumeric characters as they
# give dplyr a hard time

library(dplyr)
library(data.table)

# Read the data
products = read.csv("./data/ulta_cleaned.csv")
products = dplyr::select(products, -X)
products$size = paste(products$default_size_value, products$default_size_unit)
products = products %>%
  filter(top_level_category != "Tools & Brushes") %>%
  filter(top_level_category != "Nails") %>%
  filter(secondary_category != "Tools")

# Remove non-alphaneumeric characters
products$brand_name = gsub(" ", "_sp", x = products$brand_name, fixed = TRUE)
products$brand_name = gsub("&", "_an", x = products$brand_name, fixed = TRUE)
products$brand_name = gsub("!", "_ex", x = products$brand_name, fixed = TRUE)
products$brand_name = gsub("'", "_ap", x = products$brand_name, fixed = TRUE)
products$brand_name = gsub("~", "_ti", x = products$brand_name, fixed = TRUE)
products$brand_name = gsub("+", "_pl", x = products$brand_name, fixed = TRUE)
products$brand_name = gsub("-", "_hy", x = products$brand_name, fixed = TRUE)

# List of shady ingredients
bad = read.csv("data/bad_ingredients.csv", stringsAsFactors = FALSE)

# Get the count of products with each ingredient by brand
products$coal_tar_dyes = grepl(pattern = bad[1,2],x = products$ingredients,
                               ignore.case = TRUE)
products$formaldehyde = grepl(bad[2,2],products$ingredients, ignore.case = TRUE)
products$fragrance    = grepl(bad[3,2],products$ingredients, ignore.case = TRUE)
products$microbeads   = grepl(bad[4,2],products$ingredients, ignore.case = TRUE)
products$palm_oil     = grepl(bad[5,2],products$ingredients, ignore.case = TRUE)
products$parabens     = grepl(bad[6,2],products$ingredients, ignore.case = TRUE)
products$siloxanes    = grepl(bad[7,2],products$ingredients, ignore.case = TRUE)
products$sulfates     = grepl(bad[8,2],products$ingredients, ignore.case = TRUE)
products$sunscreen_chemicals = grepl(bad[9,2],products$ingredients,
                                     ignore.case = TRUE)

cnt_nefarious = products %>%
  group_by(brand_name) %>%
  summarise(coal_tar_dyes = sum(coal_tar_dyes), 
            formaldehyde = sum(formaldehyde),
            fragrance = sum(fragrance),
            microbeads = sum(microbeads),
            palm_oil = sum(palm_oil),
            parabens = sum(parabens),
            siloxanes = sum(siloxanes),
            sulfates = sum(sulfates),
            sunscreen_chemicals = sum(sunscreen_chemicals))

# Transpose the dataframe
trans = t(cnt_nefarious)
trans = data.frame(trans, stringsAsFactors = FALSE)
colnames(trans) = trans[1, ] # the first row will be the header
trans = trans[-1, ]          # remove the first row
setDT(trans, keep.rownames = TRUE)[] # change to data table
write.csv(trans, file = "data/by_brand.csv")
