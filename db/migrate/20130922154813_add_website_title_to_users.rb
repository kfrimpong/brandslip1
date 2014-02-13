class AddWebsiteTitleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website_title, :string
  end
end
