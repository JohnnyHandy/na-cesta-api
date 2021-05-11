class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.integer :name

      t.timestamps
    end
  end
end
