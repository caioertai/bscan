# require 'nokogiri'
# require 'open-uri'

# Service object
class ParseService
  def self.ensure_types_of(item)
    item[:name] = item[:name] && item[:name].text
    item[:ean] = item[:ean] && item[:ean].text.to_i
    item
  end

  def self.parse_product(url)
    # # EAN
    # @product.ean = doc.search('.presentation-offer-info__ean strong').first.text.to_i
    #
    # # Composition
    # composition = doc.search('#descricao').at("h2:contains('Composição')")
    # unless composition.nil?
    #   composition.next_element.text.split(', ').each_with_index do |ingredient_string, index|
    #     product_ingredient = ProductIngredient.new(composition_index: index, product: @product)
    #
    #     # Removes trailing dot
    #     # TODO: make better parsing methods.
    #     # E.g.: "Name1 / Name2" and "Name1/Name2" to "Name1 / Name2"
    #     # E.g.: "Aqua" should equal "Aqua / Water"
    #     # Maybe create an ingredient aliases column?
    #     ingredient_string = ingredient_string.chomp('.').strip
    #
    #     # Uses ingredients from DB or Creates and uses a new ingredient
    #     ingredient = Ingredient.find_by_name(ingredient_string)
    #     if ingredient.nil?
    #       product_ingredient.ingredient = Ingredient.create(name: ingredient_string)
    #     else
    #       product_ingredient.ingredient = ingredient
    #     end
    #     product_ingredient.save
    #
    #     @product.product_ingredients << product_ingredient
    #   end
    # end
    #
    # # Price
    # prices = doc.search('.presentation-offer__price-value strong').map { |price| price.text.delete(',').to_i }
    # @product.price = prices.sum / prices.size
  end
end
