class PagesController < ApplicationController
  def search
  end

  def search_by_ean
    @product = ScrapeService.search_by_ean(params[:ean])
  end

  def search_by_name
    @products = ScrapeService.search_by_name(params[:name])
  end
end
