class AddOnlineMediaSourceToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :online_media_source, :string
    add_column :jobs, :followers_subscribers, :string
    add_column :jobs, :job_type, :integer
  end
end
