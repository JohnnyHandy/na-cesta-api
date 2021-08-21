class ImageResource < JSONAPI::Resource
  abstract
  attributes :filename, :url
  def filename
    @model.filename.to_s
  end
  def url
    @model.url
  end
  def id
    @model.id
  end

  has_one :product
end
