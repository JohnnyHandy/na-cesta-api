class AddressResource < JSONAPI::Resource
  attributes :cep,
  :street,
  :number,
  :complement,
  :neighbourhood,
  :city,
  :state,
  :user_id

  has_one :user
  has_many :orders
end
