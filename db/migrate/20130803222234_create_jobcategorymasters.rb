class CreateJobcategorymasters < ActiveRecord::Migration
  def change
    create_table :jobcategorymasters do |t|
      t.string :category
      t.string :comment

      t.timestamps
    end
  end
end
