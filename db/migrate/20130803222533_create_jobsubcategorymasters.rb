class CreateJobsubcategorymasters < ActiveRecord::Migration
  def change
    create_table :brand_subcategory_masters do |t|
      t.integer :category_id
      t.string :sub_category
      t.string :comment

      t.timestamps
    end
  end
end
