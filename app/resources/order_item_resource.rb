class OrderItemResource < JSONAPI::Resource
  attributes :name,
    :ref,
    :color,
    :size,
    :description,
    :is_deal,
    :discount,
    :price,
    :deal_price,
    :enabled,
    :subtotal,
    :product_id

  has_one :product
  has_one :model
end
