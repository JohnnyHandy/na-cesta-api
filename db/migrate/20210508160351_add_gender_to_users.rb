class AddGenderToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :gender, :string
    add_column :users, :birthday, :datetime
    add_column :users, :document, :string
  end
end
