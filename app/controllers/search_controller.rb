# app/controllers/search_controller
class SearchController < ApplicationController
  def product_search
    if params[:search].numeric?
      product = Product.find_by_ean(params[:search]) || GrabService.by_ean(params[:search])
      redirect_to product
    else
      @products = GrabService.by_name(params[:search])
    end
  end
end
