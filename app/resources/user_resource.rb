class UserResource < JSONAPI::Resource
  attributes :name,
    :phone,
    :email,
    :gender,
    :birthday,
    :document
  has_many :addresses
  has_many :orders
end