class Product < ApplicationRecord
  belongs_to :model
  has_many_attached :images
  has_many :stocks, dependent: :delete_all
  has_many :order_items, dependent: :delete_all
  accepts_nested_attributes_for :stocks
  def image_url
    if self.images.attached?
      puts self.images
      self.images.map do |image|
        {
          id: image.id,
          filename: image.filename.to_s,
          url: image.url
        }
      end
    end
  end
end
