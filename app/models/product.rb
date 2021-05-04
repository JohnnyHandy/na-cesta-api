class Product < ApplicationRecord
  belongs_to :model
  has_many :images
  accepts_nested_attributes_for :images
end
