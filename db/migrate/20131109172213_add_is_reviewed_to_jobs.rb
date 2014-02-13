class AddIsReviewedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :is_reviewed, :integer
  end
end
