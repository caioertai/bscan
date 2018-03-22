require 'nokogiri'
require 'open-uri'

# Service object
class ScrapeService
  def self.get_page(url)
    Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
  end

  def self.search_by_name(product_name)
    @url = "https://consultaremedios.com.br"

    # Treats name to use in URL
    product_slug = I18n.transliterate(product_name.downcase.gsub('+', '%2B').gsub(' ', '+'))

    doc = get_page(@url + "/busca?termo=" + product_slug)

    doc.search('.product-block__title a').map do |e|
      # Won't follow link if product name is already on DB
      product_name = e.search('span').text
      product = Product.find_by_name(product_name)
      product ? product : get_info(@url + e.attr('href'))
    end
  end

  def self.search_by_ean(product_ean)
    url = "https://consultaremedios.com.br/busca?termo=" + product_ean.to_s
    @product = Product.find_by_ean(product_ean)
    @product.nil? ? get_info(url) : @product
  end

  def self.at_url(url)
    doc = get_page(url)
    @url = "https://consultaremedios.com.br"
    doc.search('.product-block__title a span').map do |e|
      # Won't follow link if product name is already on DB
      product = Product.find_by_name(e.text)
      product ? product : get_info(@url + e.attr('href'))
    end
  end

  def self.get_info(product_url)
    # Gets the HTML rescues and sends (Product Unavailable) if broken link
    begin
      doc = get_page(product_url)
    rescue OpenURI::HTTPError => e
      return Product.new(name: "Product from #{product_url} is unavailable");
    end

    ### Builds the product
    @product = Product.new

    # Name and doc
    @product.name = doc.search('.product-header__title').text
    @product.document = doc

    # Saves on DB and returns result
    @product.save
    @product
  end
end
