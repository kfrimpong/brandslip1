class AddCrowdSizeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :crowd_size, :string
  end
end
