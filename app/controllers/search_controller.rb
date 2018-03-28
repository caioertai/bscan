# app/controllers/search_controller
class SearchController < ApplicationController
  def by_ean
    product = Product.find_by_ean(params[:ean]) || GrabService.by_ean(params[:ean])
    redirect_to product
  end

  def by_name
    @products = GrabService.by_name(params[:name])
  end

  def close_match
    # TODO: Make this a service (able to be called on base model) that runs through all of the same model
    # as lev_search(attribute, max_distance) and matches them into a join table with the distance column
    name_to_match = params[:name_to_match].downcase

    matches = []
    Ingredient.all.each.each do |ingredient|
      similarity = SimilarityService.new(ingredient, name_to_match)
      matches << similarity if similarity.rating > 50
    end
    @close_matches = matches.sort_by { |match| -match.rating }
  end
end
