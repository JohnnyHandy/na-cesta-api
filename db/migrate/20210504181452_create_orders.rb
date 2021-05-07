class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :status
      t.integer :discount
      t.string :coupon
      t.decimal :total, precision: 6, scale: 2

      t.timestamps
    end
  end
end
