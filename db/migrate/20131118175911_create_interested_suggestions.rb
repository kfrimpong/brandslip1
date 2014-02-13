class CreateInterestedSuggestions < ActiveRecord::Migration
  def change
    create_table :interested_suggestions do |t|
      t.integer :user_id
      t.integer :suggestion_id

      t.timestamps
    end
  end
end
