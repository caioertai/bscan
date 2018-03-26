require 'nokogiri'
require 'open-uri'

# Service object
class GrabService
  def self.get_page(url)
    puts "-----\n#{url}\n-----"
    Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
  end

  def self.by_name(product_name)
    # Treats name to use in URL
    url = 'https://consultaremedios.com.br'
    product_slug = I18n.transliterate(product_name.downcase.gsub('+', '%2B').tr(' ', '+'))
    search_url = "#{url}/busca?termo=#{product_slug}"

    get_page(search_url).search('.product-block__title a').map do |e|
      # Won't follow link if product name is already on DB
      product_name = e.search('span').text
      product = Product.find_by_name(product_name)
      product ? product : create_product(url + e.attr('href'))
    end
  end

  def self.by_ean(product_ean)
    product_url = 'https://consultaremedios.com.br/busca?termo=' + product_ean.to_s
    product = Product.find_by_ean(product_ean)
    product.nil? ? create_product(product_url) : product
  end

  def self.at_url(url)
    get_page(url).search('.product-block__title a').map do |e|
      # Won't follow link if product name is already on DB
      product_name = e.search('span').text
      product = Product.find_by_name(product_name)
      product ? product : create_product("https://consultaremedios.com.br#{e.attr('href')}")
    end
  end

  def self.create_product(product_url)
    # Gets the HTML rescues and sends (Product Unavailable) if broken link

    doc = get_page(product_url)
    product = {}
    product[:name] = doc.at('.product-header__title')
    product[:ean] = doc.at('.presentation-offer-info__ean strong')
    product[:url] = product_url
    product[:document] = doc
    product = ParseService.ensure_types_of(product)

    # Saves on DB and returns result
    Product.create(product)
  rescue OpenURI::HTTPError
    Product.new(name: "Product from #{product_url} is unavailable")
  end

  def self.grab_all_from_type(type)
    current_page = 0
    while 1 != 2
      current_page += 1
      current_url = "https://consultaremedios.com.br/beleza-e-saude/cabelos/#{type}/c?pagina=#{current_page}"
      begin
        at_url(current_url)
      rescue OpenURI::HTTPError
        break
      end
    end
  end
end
