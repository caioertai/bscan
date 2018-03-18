class CreateProductIngredientReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :product_ingredient_references do |t|
      add_reference :product_ingredients, :product, foreign_key: true
      add_reference :product_ingredients, :ingredient, foreign_key: true
    end
  end
end
