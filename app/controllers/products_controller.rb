# app/controllers/search_controller
class ProductsController < ApplicationController
  before_action :authenticate_admin!, except: %i[show]
  before_action :set_product, only: %i[show edit update destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all.page params[:page]
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @attributes = Product.attribute_names - %w[document created_at updated_at]
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # GET /anomalies
  def anomalies
    anomalies = {}
    # anomalies['Unclosed ()'] = Ingredient.where("name LIKE '%[%'")
    anomalies['Is a one of'] = Ingredient.where("name LIKE '%\{%' OR '%\}%'")
    anomalies['Has curly brackets'] = Ingredient.where("name LIKE '%\{%' OR '%\}%'")
    anomalies['Has square brackets'] = Ingredient.where("name LIKE '%[%' OR '%]%'")
    anomalies['Has parenthesis'] = Ingredient.where("name LIKE '%(%' OR '%)%'")
    anomalies['Has dots'] = Ingredient.where("name LIKE '%.%'")
    anomalies['Large formula item'] = Ingredient.where('LENGTH(name) > 50')
    anomalies['EAN < 13'] = Product.where('LENGTH(ean) < 13')
    anomalies['EAN > 13'] = Product.where('LENGTH(ean) > 13')
    @anomalies_list = anomalies
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :ean)
  end
end
