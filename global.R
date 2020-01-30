# Visualize ingredients in beauty products, scraped from www.utla.com

library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(DT)
library(plotly)

# Read the product data
products = read.csv("./data/ulta_cleaned.csv")
products = dplyr::select(products, -X)
products$size = paste(products$default_size_value, products$default_size_unit)
products = products %>%
  filter(top_level_category != "Tools & Brushes") %>%
  filter(top_level_category != "Nails") %>%
  filter(secondary_category != "Tools")

# Reorder the columns
products = products[,c(2,12,13,1,8,7,6,5,4,3,10,9,14,11)]

# Add URL links
products$url_links = paste0("<a target='_blank', href='",products$url,
                            "'>",products$url,"</a>")

# Get the list of all categories
top_cats = sort(unique(products$top_level_category))
top_cats = c("All", as.character(top_cats))
top_cats = top_cats[-2]

# Read the list of commonly scrutinized ingredients
bad = read.csv("./data/bad_ingredients.csv", stringsAsFactors = FALSE)

# List of all brands to display
brands = sort(unique(products$brand_name))

# Data by brand (note non-alphaneumeric chars are replaced)
by_brand = read.csv("./data/by_brand.csv")

##### Global Variables #####

n_bars = 30        # max # of bars in the bar plots
c_bars = '#5F5CA3' # bar fill color
c_bg   = '#EDF0F5' # page bg color

##### Global Functions #####

# Runction to pull the necessary data from by_brand (replaces non-alphaneumeric
# characters)
clean = function(string){
  string = gsub(" ", "_sp", x = string, fixed = TRUE)
  string = gsub("&", "_an", x = string, fixed = TRUE)
  string = gsub("!", "_ex", x = string, fixed = TRUE)
  string = gsub("'", "_ap", x = string, fixed = TRUE)
  string = gsub("~", "_ti", x = string, fixed = TRUE)
  string = gsub("+", "_pl", x = string, fixed = TRUE)
  string = gsub("-", "_hy", x = string, fixed = TRUE)
  string
}