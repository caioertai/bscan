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
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients
end
