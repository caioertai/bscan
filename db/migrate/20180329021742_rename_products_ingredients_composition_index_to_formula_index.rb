class RenameProductsIngredientsCompositionIndexToFormulaIndex < ActiveRecord::Migration[5.1]
  def change
    rename_column :product_ingredients, :composition_index, :formula_index
  end
end
