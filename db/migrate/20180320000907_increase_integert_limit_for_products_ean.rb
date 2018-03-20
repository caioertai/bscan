class IncreaseIntegertLimitForProductsEan < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :ean, :integer, limit: 8
  end
end
