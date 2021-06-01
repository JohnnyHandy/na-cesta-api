class Order < ApplicationRecord
  enum status: { processing: 0, confirmed: 1, finished: 2 }
  has_many :order_items, dependent: :destroy
  has_many :products, :through => :order_items
  belongs_to :user
  belongs_to :address
  accepts_nested_attributes_for :order_items
end
