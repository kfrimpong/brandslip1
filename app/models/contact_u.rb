class ContactU < ActiveRecord::Base
  attr_accessible :company_name, :email, :location, :message, :name, :phone_no
end
