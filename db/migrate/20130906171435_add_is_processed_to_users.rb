class AddIsProcessedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_processed, :integer, :default => 0
  end
end
