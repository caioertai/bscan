require 'nokogiri'
require 'open-uri'

# Service object
class ScrapeService
  def self.get_page(url)
    p url
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
    # Looks for it on the DB first
    @product = Product.find_by_ean(product_ean)
    return @product unless @product.nil?

    # Tries to find online otherwise
    get_info("https://consultaremedios.com.br/busca?termo=" + product_ean.to_s)
  end

  def self.get_info(product_url)
    # Gets the HTML rescues and sends (Product Unavailable) if broken link
    begin
      doc = get_page(product_url)
    rescue OpenURI::HTTPError => e
      p "---\n#{e.message} for #{product_url}\n---"
      return Product.new(name: "Product from #{product_url} is unavailable");
    end

    ### Builds the product
    @product = Product.new

    # Name
    @product.name = doc.search('.product-header__title').text

    # EAN
    @product.ean = doc.search('.presentation-offer-info__ean strong').first.text.to_i

    # Composition
    if doc.search('hr').first
      doc.search('hr').first.next_element.next_element.text.split(', ').each_with_index do |ingredient_string, index|
        product_ingredient = ProductIngredient.new(composition_index: index, product: @product)

        # Removes trailing dot
        # TODO: make better parsing methods.
        # E.g.: "Name1 / Name2" and "Name1/Name2" to "Name1 / Name2"
        # E.g.: "Aqua" should equal "Aqua / Water"
        # Maybe create an ingredient aliases column?
        ingredient_string = ingredient_string.chomp('.').strip

        # Uses ingredients from DB or Creates and uses a new ingredient
        ingredient = Ingredient.find_by_name(ingredient_string)
        if ingredient.nil?
          product_ingredient.ingredient = Ingredient.create(name: ingredient_string)
        else
          product_ingredient.ingredient = ingredient
        end
        product_ingredient.save

        @product.product_ingredients << product_ingredient
      end
    end

    # Price
    prices = doc.search('.presentation-offer__price-value strong').map { |price| price.text.delete(',').to_i }
    @product.price = prices.sum / prices.size

    # Returns and saves result on DB
    @product.save
    @product
  end
end
