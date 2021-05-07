class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, :through => :order_items
  accepts_nested_attributes_for :order_items
  def as_json(options = {})
    super(include: { order_items: { include: :images } })
  end
end
