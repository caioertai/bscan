require 'nokogiri'
require 'open-uri'

# Service object
class ScrapeService
  def self.get_page(url)
    Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
  end

  def self.search_by_name(product_name)
    @url = "https://consultaremedios.com.br"
    product_name = product_name.downcase.gsub(' ', '+')
    doc = get_page(@url + "/busca?termo=" + product_name)

    doc.search('.product-block__title a').map do |e|
      get_info(@url + e.attr('href'))
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
    # Gets the HTML
    doc = get_page(product_url)

    ### Builds the product
    @product = Product.new

    # Name
    @product.name = doc.search('.product-header__title').text

    # EAN
    @product.ean = doc.search('.presentation-offer-info__ean strong').first.text.to_i

    # Composition
    if doc.search('hr').first
      doc.search('hr').first.next_element.next_element.text.split(', ').each_with_index do |ingredient_string, index|
        product_ingredient = ProductIngredient.new(composition_index: index)
        product_ingredient.product = @product

        # Removes trailing dot
        # TODO: make better parsing methods.
        # E.g.: "Name1 / Name2" and "Name1/Name2" to "Name1 / Name2"
        # E.g.: "Aqua" should equal "Aqua / Water"
        # Maybe create an ingredient aliases column?  
        ingredient_string = ingredient_string.chomp('.')

        # Uses ingredients from DB or Creates and uses a new ingredient
        ingredient = Ingredient.find_by_name(ingredient_string)
        p "==========="
        p ingredient
        p "==========="
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
