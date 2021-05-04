class AddModelToProduct < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :model, null: false, foreign_key: true
  end
end
