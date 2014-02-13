class ChangeTypeOfPriceInJobs < ActiveRecord::Migration
  def up
    change_column :jobs, :job_price_fixed_type, :decimal, :precision => 7, :scale => 2
  end

  def down
    change_column :jobs, :job_price_fixed_type, :decimal, :precision => 7, :scale => 2
  end
end
