class ChangeProductsEanToString < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :ean, :string
  end
end
