class Category < ApplicationRecord
  enum name: { regata: 0, shorts: 1, kit: 2, tenis: 3 }
  has_many :models
end
