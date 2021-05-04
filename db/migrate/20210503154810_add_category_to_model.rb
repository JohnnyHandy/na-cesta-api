class AddCategoryToModel < ActiveRecord::Migration[6.1]
  def change
    add_reference :models, :category, foreign_key: true
  end
end

