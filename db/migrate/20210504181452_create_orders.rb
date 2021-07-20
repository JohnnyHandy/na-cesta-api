class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :status
      t.integer :discount
      t.string :coupon
      t.string :ref
      t.string :tracking_code
      t.string :payment_id
      t.integer :payment_method
      t.integer :payment_status
      t.string :boleto_pdf
      t.decimal :total, precision: 6, scale: 2
      t.timestamps
    end
  end
end
