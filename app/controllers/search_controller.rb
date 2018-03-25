class SearchController < ApplicationController
  def search_by_ean
    product = Product.find_by_ean(params[:ean]) || GrabService.search_by_ean(params[:ean])
    redirect_to product
  end

  def search_by_name
    @products = GrabService.search_by_name(params[:name])
  end

  def lev_distance
    @close_matches = Ingredient.all.select do |ingredient|
      Text::Levenshtein.distance(params[:name_to_match], ingredient.name) < 4
    end
  end
end
