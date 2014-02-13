class AddIsAssignedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :is_assigned, :integer
    add_column :jobs, :assigned_to, :integer
  end
end
