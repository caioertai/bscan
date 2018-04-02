# app/controllers/anomalies_controller.rb
class AnomaliesController < ApplicationController
  before_action :authenticate_admin!

  # GET /anomalies
  def index
    anomalies = {}
    anomalies['Has curly brackets'] = Ingredient.where("name LIKE '%\{%' OR '%\}%'")
    anomalies['Has square brackets'] = Ingredient.where("name LIKE '%[%' OR '%]%'")
    anomalies['Has parenthesis'] = Ingredient.where("name LIKE '%(%' OR '%)%'")
    anomalies['Has dots'] = Ingredient.where("name LIKE '%.%'")
    anomalies['Large formula item'] = Ingredient.where('LENGTH(name) > 50')
    anomalies['EAN does not start with 789'] = Product.where("ean NOT LIKE '789%'")
    anomalies['EAN < 13'] = Product.where('LENGTH(ean) < 13')
    anomalies['EAN > 13'] = Product.where('LENGTH(ean) > 13')
    @anomalies_list = anomalies
  end
end
