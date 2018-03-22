class AddDocumentColumnToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :document, :string
  end
end
