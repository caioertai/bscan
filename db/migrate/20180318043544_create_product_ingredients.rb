class CreateProductIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :product_ingredients do |t|

      t.timestamps
    end
  end
end
