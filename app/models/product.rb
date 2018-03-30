# CREATE TABLE `products` (
#   `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
#   `name` VARCHAR NULL DEFAULT NULL,
#   `price` INTEGER NULL DEFAULT NULL,
#   `ean` INTEGER NULL DEFAULT NULL,
#   PRIMARY KEY (`id`)
# );
class Product < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :ean, presence: true

  belongs_to :brand
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients

  def path
    "/product/#{ean}"
  end

  (attribute_names + ['ingredients', 'brand']).each do |attribute|
    define_method :"parse_#{attribute}" do
      ParseService.send(:"parse_#{attribute}", self)
    end
  end
end
