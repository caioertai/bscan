# pages
class SearchController < ApplicationController
  # def search; end

  def search_by_ean
    product = Product.find_by_ean(params[:ean]) || GrabService.search_by_ean(params[:ean])
    redirect_to product
  end

  def search_by_name
    @products = GrabService.search_by_name(params[:name])
  end
end
