FactoryBot.define do
  factory :model do
    category
    name {'model'}
    ref { Faker::Alphanumeric.alpha(number: 10) }
    description {"Description text"}
    is_deal { [true,false].sample }
    team {rand(1..23)}
    discount {[0, rand(10..40)].sample}
    price { 25 }
    deal_price { 20 }
    enabled { [true,false].sample }
  end
end