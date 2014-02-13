class AddVideoToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :video, :string
  end
end
