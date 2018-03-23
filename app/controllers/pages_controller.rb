# pages
class PagesController < ApplicationController
  def search; end

  def search_by_ean
    @product = GrabService.search_by_ean(params[:ean])
  end

  def search_by_name
    @products = GrabService.search_by_name(params[:name])
  end
end
