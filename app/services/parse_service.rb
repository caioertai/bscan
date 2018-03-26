# require 'nokogiri'
# require 'open-uri'

# Service object
class ParseService
  def self.ensure_types_of(item)
    item[:name] = item[:name] && item[:name].text.strip
    item[:ean] = item[:ean] && item[:ean].text.strip.to_i
    item
  end

  def self.normalize_string(string)
    string.gsub('/\s+/', ' ').gsub(' / ', '/').strip.chomp('.').strip
  end

  def self.parse_ean(product)
    puts "Parsing #{product.name}"
    doc = Nokogiri::HTML(product.document)
    ean = doc.at('.presentation-offer-info__ean strong')
    product.ean = ean.nil? ? '' : ean.text.strip
    product.save
    product.ean
  end

  def self.parse_brand(product)
    puts "Parsing #{product.name}"
    doc = Nokogiri::HTML(product.document)
    product_header = doc.search('.product-header__infos').last
    brand = product_header.at('.cr-icon-brand.product-block__meta-icon')
    product.brand = brand.nil? ? '' : brand.parent.text.strip
    product.save
    product.brand
  end

  def self.parse_factory(product)
    puts "Parsing #{product.name}"
    doc = Nokogiri::HTML(product.document)
    product_header = doc.search('.product-header__infos').last
    factory = product_header.at('.cr-icon-factory.product-block__meta-icon')
    product.factory = factory.nil? ? '' : factory.parent.text.strip
    product.save
    product.factory
  end

  def self.parse_ingredients(product)
    composition = Nokogiri::HTML(product.document).at("#descricao h2:contains('Composição')")
    puts "Parsing #{product.name}"
    return if composition.nil?
    composition.next_element.text.split(',').each_with_index do |ing_str, index|
      # TODO: change composition to formula on the models.
      ing_str = normalize_string(ing_str)

      next if product.ingredients.find_by_name(ing_str)

      ingredient = Ingredient.find_by_name(ing_str) || Ingredient.create(name: ing_str)
      product.product_ingredients << ProductIngredient.new(composition_index: index, product: product, ingredient: ingredient)
    end
    product.ingredients
  end

  def self.parse_price(product)
    # TODO: parse_price
  end
end
