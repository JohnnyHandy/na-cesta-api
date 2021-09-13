FactoryBot.define do
  factory :order do
    association :user
    association :address
    status { [0, 1, 2, 3].sample} 
    payment_status { [0, 1].sample }
    payment_method { [0, 1].sample }
    boleto_pdf { 'boleto' }
    discount { rand(20..40) }
    ref { Faker::Alphanumeric.alpha(number: 10) }
    coupon { 'coupon' }
    total { 0 }
  end
  
  trait :with_order_item do
    after(:create) do |order|
      create(:order_item, order_id: order.id)
    end
  end
end