FactoryBot.define do
  factory :address do
    association :user
    cep { Faker::Address.zip_code }
    street { Faker::Address.street_name }
    number { Faker::Address.building_number }
    complement { Faker::Address.secondary_address }
    neighbourhood { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state }
  end
end