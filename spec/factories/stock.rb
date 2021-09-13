FactoryBot.define do
  factory :stock do
    product
    size {'P'}
    quantity {rand(1..10)}
  end
end