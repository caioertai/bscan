# CREATE TABLE `ingredients` (
#   `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
#   `name` VARCHAR NULL DEFAULT NULL,
#   `description` VARCHAR NULL DEFAULT NULL,
#   PRIMARY KEY (`id`)
# );
class Ingredient < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  has_many :product_ingredients, dependent: :destroy
  has_many :products, through: :product_ingredients
  default_scope { order('name ASC') }
end
