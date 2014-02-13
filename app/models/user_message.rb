class UserMessage < ActiveRecord::Base
  attr_accessible :from_user, :message_body, :message_title, :to_user
  
  attr_writer :from, :to
end
