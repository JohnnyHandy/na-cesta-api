class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :ref
      t.string :color
      t.text :description, :default => nil
      t.boolean :is_deal, :default => nil
      t.integer :discount, :default => nil
      t.decimal :price, precision: 6, scale: 2, :default => nil
      t.decimal :deal_price, precision: 6, scale: 2, :default => nil
      t.boolean :enabled, :default => nil

      t.timestamps
    end
  end
end
