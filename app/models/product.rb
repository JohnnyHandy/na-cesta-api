class Product < ApplicationRecord
  belongs_to :model
  has_many :images, dependent: :delete_all
  has_many :order_items
  delegate :image, :to => :order_items, :allow_nil => true
  accepts_nested_attributes_for :images
end
