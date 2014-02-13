class BrandslipSuggestion < ActiveRecord::Base
  attr_accessible :assigned_to, :category, :city, :comment, :crowd_size, :description, :followers_subscribers, :is_assigned, :is_mark_done, :is_reviewed, :online_media_source, :price, :proof_selector, :start_date, :state, :sub_category, :suggestion_type, :time, :title, :user_id, :valid_for, :video
end
