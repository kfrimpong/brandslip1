class AddYoutubeChannelLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :youtube_channel_link, :string
    add_column :users, :youtube_subscribers, :string
    add_column :users, :vine_handle, :string
    add_column :users, :vine_followers, :string
    add_column :users, :instagram_handle, :string
    add_column :users, :instagram_followers, :string
  end
end
