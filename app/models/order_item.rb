class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  has_many :images, :through => :product
end
