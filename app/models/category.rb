class Category < ApplicationRecord
  enum name: { biquini: 1, maio: 2, saida: 3 }
  has_many :models
end
