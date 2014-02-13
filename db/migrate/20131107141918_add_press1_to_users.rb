class AddPress1ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :press_1, :string
    add_column :users, :press_2, :string
  end
end
