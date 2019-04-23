class AddCategoryNameToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :category_name, :string
  end
end
