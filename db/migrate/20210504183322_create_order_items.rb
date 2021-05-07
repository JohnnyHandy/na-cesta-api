class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.string :name
      t.string :color
      t.string :size
      t.text :description
      t.boolean :is_deal
      t.integer :discount
      t.decimal :price, precision: 6, scale: 2
      t.decimal :deal_price, precision: 6, scale: 2
      t.integer :quantity
      t.decimal :subtotal, precision: 6, scale: 2
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
