# Visualize ingredients in beauty products, scraped from www.utla.com

library(shiny)
library(dplyr)
library(stringr)
library(shinydashboard)
# library(plotly)
# library(DT)

# Read the data
products = read.csv("./data/ulta_cleaned.csv")
products = select(products, -X, -Unnamed..0)
products$size = paste(products$default_size_value, products$default_size_unit)
products = products %>%
  filter(top_level_category != "Tools & Brushes")

# Reorder the columns
products = products[,c(2,12,13,1,8,7,6,5,4,3,10,9,14)]

# Get the list of all categories
top_cats = sort(unique(products$top_level_category))
secondary_cats = sort(unique(products$secondary_category))

# List of shady ingredients
bad = read.csv("data/bad_ingredients.csv", stringsAsFactors = FALSE)
#filter(products, str_detect(ingredients, bad[1,2]))
