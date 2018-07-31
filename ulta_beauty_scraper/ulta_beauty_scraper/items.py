# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class UltaBeautyScraperItem(scrapy.Item):
	ingredients = scrapy.Field()
	product_name = scrapy.Field()
	brand_name = scrapy.Field()
	default_size_value = scrapy.Field()
	default_size_unit = scrapy.Field()
	default_price = scrapy.Field()
	categories = scrapy.Field()
	product_description = scrapy.Field()
	review_count = scrapy.Field()
	review_avg_rating = scrapy.Field()
	url = scrapy.Field()