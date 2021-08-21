class ModelResource < JSONAPI::Resource
  attributes :ref, :name, :description, :is_deal, :discount, :team, :price, :deal_price, :enabled, :category_id
  has_many :products
  has_one :category
  def fetchable_fields
    super
  end
end
