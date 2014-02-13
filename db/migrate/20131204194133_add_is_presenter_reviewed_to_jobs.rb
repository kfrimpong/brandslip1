class AddIsPresenterReviewedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :is_presenter_reviewed, :integer
    add_column :brandslip_suggestions, :is_presenter_reviewed, :integer
    add_column :jobs, :is_brand_reviewed, :integer
    add_column :brandslip_suggestions, :is_brand_reviewed, :integer
  end
end
