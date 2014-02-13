class AddSubCategoryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sub_category, :integer
  end
end
