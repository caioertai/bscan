class RemoveBrandFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :brand
  end
end
