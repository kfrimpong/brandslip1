class UserJobProposal < ActiveRecord::Base
  attr_accessible :estimate_delivery_date, :is_place_mine_at_the_top, :is_submit_later, :job_id, :my_earning, 
      :proposal_cost, :proposal_details, :user_id, :user_name
  
  validates_presence_of :proposal_cost, :proposal_details
  
  validates :proposal_cost, :numericality => true, :allow_nil => true
  
  attr_writer :user_name 
end
