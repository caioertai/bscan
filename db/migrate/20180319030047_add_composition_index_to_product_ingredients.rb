class AddCompositionIndexToProductIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :product_ingredients, :composition_index, :integer
  end
end
