class ModelResource < JSONAPI::Resource
  attributes : :ref, :name, :description, :is_deal, :discount, :team, :price, :deal_price, :enabled
  has_many: 

end
