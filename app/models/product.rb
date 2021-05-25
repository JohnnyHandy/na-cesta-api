class Product < ApplicationRecord
  belongs_to :model
  has_many_attached :images
  has_many :order_items, dependent: :delete_all
  def image_url
    if self.images.attached?
      puts self.images
      self.images.map do |image|
        puts image.methods
        {
          id: image.id,
          filename: image.filename.to_s,
          url: image.url
        }
      end
    end
  end
end
