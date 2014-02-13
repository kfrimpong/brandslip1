class Job < ActiveRecord::Base
  
  attr_accessible :job_category, :job_description, :job_price_fixed_type, :job_price_hour_range, 
                  :job_price_type, :job_skill, :job_start_date, :job_sub_category, :job_title, 
                  :job_valid_for, :job_user_id, :crowd_size, :time, :proof_selector, :city, :state,
                  :followers_subscribers, :online_media_source, :job_type
                
#  validates_presence_of :job_title, :job_description, :job_category, :job_sub_category, :job_start_date,
#                        :job_price_fixed_type, :crowd_size, :time, :proof_selector, :city, :state

#  validates_format_of :job_price_fixed_type, :with =>  /(\$[0-9,]+(\.[0-9]{2})?)/
end
