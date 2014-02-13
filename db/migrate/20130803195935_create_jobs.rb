class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :job_title
      t.text :job_description
      t.integer :job_category
      t.integer :job_sub_category
      t.string :job_skill
      t.integer :job_price_type
      t.string :job_price_hour_range
      t.string :job_price_fixed_type
      t.string :job_valid_for
      t.date :job_start_date
      t.integer :job_user_id

      t.timestamps
    end
  end
end
