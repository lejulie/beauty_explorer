import scrapy
from ulta_beauty_scraper.items import UltaBeautyScraperItem
from math import floor
import re

class UltaSpider(scrapy.Spider):
	name = "ulta_spider"
	allowed_urls = ['https://www.ulta.com/']
	start_urls = ['https://www.ulta.com/skin-care-cleansers?N=2794','https://www.ulta.com/skin-care-moisturizers?N=2796',\
	'https://www.ulta.com/skin-care-treatment-serums?N=27cs','https://www.ulta.com/skin-care-eye-treatments?N=270k',\
	'https://www.ulta.com/skin-care-suncare?N=27fe','https://www.ulta.com/skin-care-supplements?N=2712',\
	'https://www.ulta.com/skin-care-mother-baby?N=2715','https://www.ulta.com/makeup-face?N=26y3',\
	'https://www.ulta.com/makeup-eyes?N=26yd','https://www.ulta.com/makeup-lips?N=26yq',\
	'https://www.ulta.com/hair-shampoo-conditioner?N=27ih','https://www.ulta.com/hair-treatment?N=26xy',\
	'https://www.ulta.com/hair-styling-products?N=26xf','https://www.ulta.com/hair-color?N=26xs',\
	'https://www.ulta.com/bath-body-bath-shower?N=26uy','https://www.ulta.com/bath-body-body-moisturizers?N=26v3',\
	'https://www.ulta.com/bath-body-hand-foot-care?N=27ic','https://www.ulta.com/bath-body-personal-care?N=27i3',\
	'https://www.ulta.com/bath-body-suncare?N=276b']

	def parse(self, response):
		# Count of total items in this category
		total_items = response.xpath('//h2[@class="search-res-title"]/span[1]/text()').extract()[0]
		total_items = int(total_items)

		# Get the urls for all items on the page
		items = response.xpath('//div[@id="product-category-cont"]//ul/li')

		# Number of items/page
		items_per_page = len(items)

		# Product list pages to crawl
		max_page = floor(total_items / items_per_page) * items_per_page
		num_lis = list(range(0,max_page+1,items_per_page))
		base_url = re.sub("&.*","",response.request.url)
		pages_of_items = [base_url+"&No="+str(n) for n in num_lis]

		# for every page, get the list of urls for all products
		for page in pages_of_items:
			#print("\n\n\n"+"Item page to crawl: ",page+'\n\n\n')
			yield scrapy.Request(url = page, callback=self.prase_results_page)		

	# Parse individual results page to get urls of product pages
	def prase_results_page(self, response):
		prod_urls = response.xpath('//div[@id="product-category-cont"]//ul/li')
		prod_urls = ["https://www.ulta.com"+i.xpath('.//a/@href').extract()[0] for i in prod_urls]
		
		for prod in prod_urls:
			yield scrapy.Request(url=prod, callback=self.parse_prod_page)

	# Parse individual product page to get data on each product
	def parse_prod_page(self, response):
		# Brand
		try:
			brand = response.xpath('//a[@class="Anchor ProductMainSection__brandAnchor"]/text()').extract()[0]
		except IndexError:
			brand = "None"

		# Product name
		try:
			name = response.xpath('//span[@class="ProductMainSection__productName"]/text()').extract()[0]
		except IndexError:
			name = "None"

		# Ingredients
		try:
			ingredients = response.xpath('//div[@class="ProductDetail__ingredients"]/div[2]//text()').extract()[0]
		except IndexError:
			ingredients = "None"

		# Product size and size unit
		try:
			size_info = response.xpath('//p[@class="ProductMainSection__itemNumber"]/text()').extract()
			size = size_info[0]
			size_unit = size_info[2]
		except IndexError:
			size_info = "None"
			size_unit = "None"

		# Price
		try:
			price = response.xpath('//span[@class="ProductPricingPanel__price"]/text()').extract()[0]
		except IndexError:
			price = "None"

		# Description 
		try:
			description = response.xpath('//div[@class="ProductDetail__productDetails"]/div[2]//text()').extract()[0]
		except IndexError:
			description = "None"

		# Count of reviews
		try:
			review_count = response.xpath('//div[@class="RatingPanel__reviewsCount"]/text()').extract()[0].replace("(","").replace(")","")
		except IndexError:
			review_count = "None"

		# Review avg rating
		try:
			review_avg_rating = response.xpath('//div[@class="RatingPanel"]/div/div[2]/label/text()').extract()[0]
		except IndexError:
			review_avg_rating = "None"

		# Category breadcrumbs
		try:
			categories = response.xpath('//div[@class="Breadcrumb"]/ul/li/a/text()').extract()
		except IndexError:
			categories = "None"

		# put everything in an item
		item = UltaBeautyScraperItem()
		item["brand_name"] = brand
		item["product_name"] = name
		item["ingredients"] = ingredients
		item["default_size_value"] = size
		item["default_size_unit"] = size_unit
		item["default_price"] = price
		item["categories"] = categories
		item["product_description"] = description
		item["review_count"] = review_count
		item["review_avg_rating"] = review_avg_rating
		item["url"] = response.request.url

		yield item


