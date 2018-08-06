# Visualize ingredients in beauty products, scraped from www.utla.com

library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(DT)
library(plotly)

# Read the data
products = read.csv("./data/ulta_cleaned.csv")
products = dplyr::select(products, -X, -Unnamed..0)
products$size = paste(products$default_size_value, products$default_size_unit)
products = products %>%
  filter(top_level_category != "Tools & Brushes") %>%
  filter(top_level_category != "Nails") %>%
  filter(secondary_category != "Tools")

# Reorder the columns
products = products[,c(2,12,13,1,8,7,6,5,4,3,10,9,14)]

# Get the list of all categories
top_cats = sort(unique(products$top_level_category))
top_cats = c("All", as.character(top_cats))
# secondary_cats = sort(unique(products$secondary_category))
# secondary_cats = c("All", as.character(secondary_cats))
# cat_map = products %>%
#   dplyr::select(top_level_category, secondary_category) %>%
#   unique()

# List of shady ingredients
bad = read.csv("data/bad_ingredients.csv", stringsAsFactors = FALSE)

##### Global Variables #####
n_bars = 30        # max # of bars in the bar plots
c_bars = '#BF9ACA' # bar fill color
c_bg     = '#EDF0F5' # page bg color