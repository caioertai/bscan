# CREATE TABLE `product_ingredients` (
#   `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
#   `ingredient_id` INTEGER NULL DEFAULT NULL,
#   `product_id` INTEGER NULL DEFAULT NULL,
#   PRIMARY KEY (`id`)
# );
class ProductIngredient < ApplicationRecord
  validates :composition_index, presence: true
  belongs_to :product
  belongs_to :ingredient
end
