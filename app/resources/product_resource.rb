class ProductResource < JSONAPI::Resource
  attributes :name,
  :ref,
  :color,
  :description,
  :is_deal,
  :discount,
  :price,
  :deal_price,
  :enabled,
  :model_id,
  :images,
  :stocks,
  :updated_at,
  :created_at
  
  def images
    if @model.images.attached?
      @model.images.each do |image|
        p image.blob
      end
      @model.images.reject{ |image| image.blob.nil? }.map do |image|
        next if image.nil?
        {
          id: image.id,
          filename: image.filename.to_s,
          url: image.url
        }
      end
    end
  end

  def stocks
    if @model.stocks
      @model.stocks.map do |stock|
        {
          id: stock.id,
          size: stock.size,
          quantity: stock.quantity,
          product_id: @model.id
        }
      end
    end
  end

  has_one  :model
  has_many :stocks
  has_many :images
  has_many :order_items
end
