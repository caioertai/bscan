# # Service object
# class ScrapeService
#   def self.search(search, url = "https://consultaremedios.com.br")
#     @url = "https://consultaremedios.com.br"
#     search_by_name(search)
#   end
#
#   def self.get_page(url)
#     Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
#   end
#
#   def self.search_by_name(product_name)
#     @url = "https://consultaremedios.com.br"
#     product_name = product_name.downcase.gsub(' ', '+')
#     doc = get_page(@url + "/busca?termo=" + product_name)
#
#     doc.search('.product-block__title a').map do |e|
#       get_info(e.attr('href'))
#     end
#   end
#
#   def self.search_by_ean(product_ean)
#     # @url = "https://consultaremedios.com.br"
#     # doc = get_page("https://consultaremedios.com.br/busca?termo=" + product_ean.to_s)
#     # product_name = doc.search('h1.page-header').text.strip.match(/\A(.+)$/)[1]
#     # product_url = '/' + product_name.parameterize.downcase.gsub(' ', '-') + '/p'
#
#     get_info("https://consultaremedios.com.br/busca?termo=" + product_ean.to_s)
#   end
#
#   def self.get_info(product_url)
#     doc = get_page(@url + product_url)
#     info = {}
#     doc.search('.product-header__title').each { |e| info[:name] = e.text }
#     doc.search('hr').each { |e| info[:composition] = e.next_element.next_element.text.split(', ') }
#     info
#   end
# end
