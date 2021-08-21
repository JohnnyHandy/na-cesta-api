class StockResource < JSONAPI::Resource
  attributes :size, :quantity, :product_id
  has_one :product
end
