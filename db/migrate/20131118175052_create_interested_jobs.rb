class CreateInterestedJobs < ActiveRecord::Migration
  def change
    create_table :interested_jobs do |t|
      t.integer :user_id
      t.integer :job_id

      t.timestamps
    end
  end
end
