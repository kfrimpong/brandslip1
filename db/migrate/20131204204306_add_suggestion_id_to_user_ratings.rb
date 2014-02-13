class AddSuggestionIdToUserRatings < ActiveRecord::Migration
  def change
    add_column :user_ratings, :suggestion_id, :integer
  end
end
