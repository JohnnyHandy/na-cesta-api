FactoryBot.define do
  factory :product do
    model
    name {'product'}
    ref { Faker::Alphanumeric.alpha(number: 10) }
    description {"Description text"}
    is_deal { [true,false].sample }
    discount {[0, rand(10..40)].sample}
    price { 25 }
    deal_price { 20 }
    enabled { [true,false].sample }
  end
  trait :with_stock do
    after(:create) do |product|
      create(:stock, product_id: product.id)
    end
  end
end