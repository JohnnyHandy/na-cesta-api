class CreateModels < ActiveRecord::Migration[6.1]
  def change
    create_table :models do |t|
      t.string :ref
      t.string :name
      t.text :description
      t.boolean :is_deal
      t.integer :discount
      t.decimal :price, precision: 6, scale: 2
      t.decimal :deal_price, precision: 6, scale: 2
      t.boolean :enabled

      t.timestamps
    end
  end
end
