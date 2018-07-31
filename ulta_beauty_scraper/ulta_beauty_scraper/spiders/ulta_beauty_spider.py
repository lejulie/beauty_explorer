import scrapy
from math import floor
from ulta_beauty_scraper.items import UltaBeautyScraperItem

class UltaSpider(scrapy.Spider):
	name = "ulta_spider"
	allowed_urls = ['https://www.ulta.com/']
	start_urls = ['https://www.ulta.com/skin-care-cleansers?N=2794']

	def parse(self, response):
		# Count of pages listing products for this category
		# pg_count = response.xpath('//span[@class="upper-limit"]/text()').extract()[0].replace("of ","")
		# pg_count = int(pg_count)

		# Count of total items in this category
		total_items = response.xpath('//h2[@class="search-res-title"]/span[1]/text()').extract()[0]
		total_items = int(total_items)

		# Get the urls for all items on the page
		items = response.xpath('//div[@id="product-category-cont"]//ul/li')
		urls = ["https://www.ulta.com"+i.xpath('.//a/@href').extract()[0] for i in items]

		# Number of items/page
		items_per_page = len(urls)

		# Product list pages to crawl
		max_page = floor(total_items / items_per_page) * items_per_page
		num_lis = list(range(items_per_page,max_page+1,items_per_page))
		pages_of_items = ["https://www.ulta.com/skin-care-cleansers?N=2794&No="+str(n) for n in num_lis]


		with open(".test-ulta-2.txt", "w") as f:
			f.write("Pages to crawl\n"+"-"*40+'\n')
			for u in pages_of_items:
				f.write(u+'\n')
			f.write("\nItem urls to crawl"+"-"*40+'\n')
			for i in urls:
				f.write(i+'\n')


# class BudgetSpider(Spider):
#     name = "budget_spider"
#     allowed_urls = ['https://www.the-numbers.com/']
#     start_urls = ['https://www.the-numbers.com/movie/budgets/all/' + str(100*i+1) for i in range(55)]
#
#     def parse(self, response):
#         rows = response.xpath('//*[@id="page_filling_chart"]/center/table//tr')
#         for row in rows:
#             RDate = row.xpath('./td[2]/a/text()').extract_first()
#             Title = row.xpath('./td[3]/b/a/text()').extract_first()
#             PBudget = row.xpath('./td[4]/text()').extract_first()
#             DomesticG = row.xpath('./td[5]/text()').extract_first()
#             WorldwideG = row.xpath('./td[6]/text()').extract_first()
#
#             item = BudgetItem()
#             item['RDate'] = RDate
#             item['Title'] = Title
#             item['PBudget'] = PBudget
#             item['DomesticG'] = DomesticG
#             item['WorldwideG'] = WorldwideG
#
#             yield item