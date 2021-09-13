FactoryBot.define do
  factory :user do
    name { 'User name' }
    email { Faker::Internet.email }
    document {Faker::Alphanumeric.alpha(number: 10)}
    password { 'password' }
    password_confirmation { 'password' }
  end
  trait :with_address do
    after(:create) do |user|
      create(:address, user_id: user.id)
    end
  end
  trait :with_order_and_address do
    after(:create) do |user|
      address = create(:address, user_id: user.id)
      create(:order, user_id: user.id, address_id: address.id)
    end
  end
end