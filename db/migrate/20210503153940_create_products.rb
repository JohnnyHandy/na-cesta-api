class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :color
      t.string :size
      t.text :description
      t.boolean :is_deal
      t.integer :discount
      t.decimal :price, precision: 4, scale: 2
      t.decimal :deal_price, precision: 4, scale: 2
      t.integer :in_stock
      t.boolean :enabled

      t.timestamps
    end
  end
end
