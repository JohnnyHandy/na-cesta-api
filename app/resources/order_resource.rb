class OrderResource < JSONAPI::Resource
  attributes :status,
    :discount,
    :coupon,
    :ref,
    :tracking_code,
    :payment_id,
    :payment_method,
    :payment_status,
    :boleto_pdf,
    :total,
    :user_id,
    :address_id,
    :user,
    :created_at,
    :address,
    :order_items
  has_many :order_items
  has_many :products, :through => :order_items
  has_one :user
  has_one :address
  def user
    JSON.parse(@model.user.to_json)
  end

  def address
    JSON.parse(@model.address.to_json)
  end
  
end
