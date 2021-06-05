class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :cep, null: false
      t.string :street, null: false
      t.string :number, null: false
      t.string :complement, null: false
      t.string :neighbourhood, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
