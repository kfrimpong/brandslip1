class CreateUserSuggestionProposals < ActiveRecord::Migration
  def change
    create_table :user_suggestion_proposals do |t|
      t.text :proposal_details
      t.decimal :proposal_cost, :precision => 7, :scale => 2
      t.integer :suggestion_id
      t.integer :user_id

      t.timestamps
    end
  end
end
