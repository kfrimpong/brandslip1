class Jobsubcategorymaster < ActiveRecord::Base
  attr_accessible :category_id, :comment, :sub_category
  set_table_name "brand_subcategory_masters"
end
