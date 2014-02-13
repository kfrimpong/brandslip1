class AddPressTitleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :press_title, :string
  end
end
