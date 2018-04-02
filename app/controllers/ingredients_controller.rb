# app/controllers/ingredients_controller.rb
class IngredientsController < ApplicationController
  before_action :set_ingredient, only: %i[show edit update destroy]

  # GET /ingredients
  # GET /ingredients.json
  def index
    @ingredients = Ingredient.all.page params[:page]
  end

  # GET /ingredients/1
  # GET /ingredients/1.json
  def show
    @attributes = Ingredient.attribute_names - %w[created_at updated_at]
  end

  # GET /ingredients/new
  def new
    @ingredient = Ingredient.new
  end

  # GET /ingredients/1/edit
  def edit; end

  # POST /ingredients
  # POST /ingredients.json
  def create
    @ingredient = Ingredient.new(ingredient_params)

    respond_to do |format|
      if @ingredient.save
        format.html { redirect_to @ingredient, notice: 'Ingredient was successfully created.' }
        format.json { render :show, status: :created, location: @ingredient }
      else
        format.html { render :new }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingredients/1
  # PATCH/PUT /ingredients/1.json
  def update
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        format.html { redirect_to @ingredient, notice: 'Ingredient was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingredient }
      else
        format.html { render :edit }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.json
  def destroy
    @ingredient.destroy
    respond_to do |format|
      format.html { redirect_to ingredients_url, notice: 'Ingredient was successfully destroyed.' }
      format.json { head :no_content }
    end
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ingredient_params
    params.require(:ingredient).permit(:name, :description)
  end
end
