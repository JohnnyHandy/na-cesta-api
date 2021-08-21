class RegistrationResource < JSONAPI::Resource
  attributes :name,
  :email,
  :document,
  :phone,
  :gender,
  :addresses_attributes,
  :password,
  :password_confirmation
end

