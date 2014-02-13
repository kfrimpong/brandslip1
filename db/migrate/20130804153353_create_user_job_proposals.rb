class CreateUserJobProposals < ActiveRecord::Migration
  def change
    create_table :user_job_proposals do |t|
      t.text :proposal_details
      t.string :proposal_cost
      t.string :my_earning
      t.integer :is_submit_later
      t.integer :is_place_mine_at_the_top
      t.date :estimate_delivery_date
      t.integer :job_id
      t.integer :user_id

      t.timestamps
    end
  end
end
