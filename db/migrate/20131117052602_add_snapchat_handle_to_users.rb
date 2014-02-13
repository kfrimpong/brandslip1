class AddSnapchatHandleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :snapchat_handle, :string
    add_column :users, :snapchat_followers, :string
  end
end
