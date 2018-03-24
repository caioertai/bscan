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

  def self.save_brand(product)
    p "Parsing #{product.name}"
    doc = Nokogiri::HTML(product.document)
    product_header = doc.at('.product-header__infos')
    brand = product_header.at('.cr-icon-brand.product-block__meta-icon')
    return if brand.nil?
    product.brand = brand.parent.text.strip
    product.save
    product.brand
  end

  def self.save_formula(product)
    composition = Nokogiri::HTML(product.document).at("#descricao h2:contains('Composição')")
    p "Parsing #{product.name}"
    return if composition.nil?
    composition.next_element.text.split(',').each_with_index do |ing_str, index|
      # TODO: change composition to formula on the models.
      # TODO: Maybe create an ingredient aliases column?
      ing_str = normalize(ing_str)

      next if product.ingredients.find_by_name(ing_str)

      ingredient = Ingredient.find_by_name(ing_str) || Ingredient.create(name: ing_str)
      product.product_ingredients << ProductIngredient.new(composition_index: index, product: product, ingredient: ingredient)
    end
    product.ingredients
  end

  def self.save_group_formulas(array)
    array.each do |product|
      save_formula(product)
      array.count
    end
  end

  def self.save_price(product)

  end
end