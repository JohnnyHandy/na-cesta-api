class Category < ApplicationRecord
  enum name: { biquini: 0, maio: 1, saida: 2 }
  has_many :models
end
