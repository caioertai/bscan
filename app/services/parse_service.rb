# require 'nokogiri'
# require 'open-uri'

# Service object
class ParseService
  def self.ensure_types_of(item)
    item[:name] = item[:name] && item[:name].text.strip
    item[:ean] = item[:ean] && item[:ean].text.strip.to_i
    item
  end

  def self.normalize(string)
    string.strip.gsub('/\s+/', ' ').gsub(' / ', '/').chomp('.')
  end

  def self.save_formula(product)
    composition = Nokogiri::HTML(product.document).at("#descricao h2:contains('Composição')")
    return if composition.nil?
    composition.next_element.text.split(',').each_with_index do |ing_str, index|
      # TODO: change composition to formula on the models.
      # TODO: Maybe create an ingredient aliases column?
      ing_str = normalize(ing_str)
      next if product.ingredients.find_by_name(ing_str)

      ingredient = Ingredient.create(name: ing_str)
      product.product_ings << ProductIngredient.new(composition_index: index, product: product, ingredient: ingredient)
    end
  end
end
