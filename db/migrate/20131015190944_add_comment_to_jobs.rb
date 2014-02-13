class AddCommentToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :is_mark_done, :integer
    add_column :jobs, :comment, :text
  end
end
