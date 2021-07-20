class Order < ApplicationRecord
  enum status: { authorizing: 0, confirmed: 1, shipping: 2, delivered: 3 }
  enum payment_status: { processing: 0, done: 1 }
  enum payment_method: { card: 0, boleto: 1 }
  has_many :order_items, dependent: :destroy
  has_many :products, :through => :order_items
  belongs_to :user
  belongs_to :address
  accepts_nested_attributes_for :order_items
end
