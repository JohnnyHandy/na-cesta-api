FactoryBot.define do  
  factory :order_item do
    order
    product { create(:product, :with_stock) }
    name { product.name }
    color { product.color }
    size { product.stocks.sample.size }
    description { product.description }
    is_deal { product.is_deal }
    discount { product.discount }
    price { product.price }
    deal_price { product.deal_price }
    quantity { product.stocks.sample.quantity }
    subtotal { product.price * product.stocks.sample.quantity }
  end
end