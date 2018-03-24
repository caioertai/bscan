class AddFactoryToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :factory, :string
  end
end
