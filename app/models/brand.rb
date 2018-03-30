# app/models/brand.rb
class Brand < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :products
end
