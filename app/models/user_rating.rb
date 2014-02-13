class UserRating < ActiveRecord::Base
  attr_accessible :from_user, :job_id, :rating, :review, :to_user, :suggestion_id
end
