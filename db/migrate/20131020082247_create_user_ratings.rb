class CreateUserRatings < ActiveRecord::Migration
  def change
    create_table :user_ratings do |t|
      t.integer :from_user
      t.integer :to_user
      t.integer :job_id
      t.decimal :rating, :precision => 5, :scale => 2
      t.text :review

      t.timestamps
    end
  end
end
