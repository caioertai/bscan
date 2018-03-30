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
    # TODO: Validate by starting with 789 and having 13 digits
    puts "Parsing #{product.name}"
    doc = Nokogiri::HTML(product.document)
    ean = doc.at('.presentation-offer-info__ean strong')
    product.ean = ean.nil? ? '' : ean.text.strip
    product.save
  end

  def self.parse_brand(product)
    puts "Parsing #{product.name}"
    doc = Nokogiri::HTML(product.document)
    product_header = doc.search('.product-header__infos').last
    brand = product_header.at('.cr-icon-brand.product-block__meta-icon')
    return if brand.nil?
    brand = brand.parent.text.strip

    product.brand = Brand.find_by_name(brand) || Brand.create(name: brand)
    product.save
  end

  def self.parse_factory(product)
    puts "Parsing #{product.name}"
    doc = Nokogiri::HTML(product.document)
    product_header = doc.search('.product-header__infos').last
    factory = product_header.at('.cr-icon-factory.product-block__meta-icon')
    product.factory = factory.nil? ? '' : factory.parent.text.strip
    product.save
  end

  def self.parse_ingredients(product)
    formula = Nokogiri::HTML(product.document).at("#descricao h2:contains('Composição')")
    # puts "Parsing #{product.name}"
    return if formula.nil?
    formula.next_element.text.split(',').each_with_index do |ing_str, index|
      ing_str = normalize_string(ing_str)

      next if product.ingredients.find_by_name(ing_str)

      ingredient = Ingredient.find_by_name(ing_str) || Ingredient.create(name: ing_str)
      product.product_ingredients << ProductIngredient.new(formula_index: index, product: product, ingredient: ingredient)
    end
    product.ingredients
  end

  def self.parse_price(product)
    # TODO: parse_price
  end
end
