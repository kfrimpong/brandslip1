class AddCityToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :city, :string
    add_column :jobs, :state, :string
  end
end
