require 'nokogiri'
require 'open-uri'
# require_relative '../services/scrape'

class PagesController < ApplicationController
  def search
  end

  def search_by_ean
    @product = ScrapeService.search_by_ean(params[:ean])
  end
end




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
    @product = Product.new
    get_info("https://consultaremedios.com.br/busca?termo=" + product_ean.to_s)
  end

  def self.get_info(product_url)
    # Gets the HTML
    doc = get_page(product_url)

    # Builds the hash
    @product.name = doc.search('.product-header__title').text
    if doc.search('hr').first
      doc.search('hr').first.next_element.next_element.text.split(', ').each_with_index do |ingredient, index|
        product_ingredient = ProductIngredient.new(composition_index: index)
        product_ingredient.product = @product
        product_ingredient.ingredient = Ingredient.new(name: ingredient)
        @product.product_ingredients << product_ingredient
      end
    end

    prices = doc.search('.presentation-offer__price-value strong').map { |price| price.text.delete(',').to_i }
    @product.price = prices.sum / prices.size

    @product
  end
end
