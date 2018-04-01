class BrandsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
  end
end
