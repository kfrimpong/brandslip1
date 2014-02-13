class AddProofSelectorToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :proof_selector, :string
  end
end
