class UserSuggestionProposal < ActiveRecord::Base
  attr_accessible :proposal_cost, :proposal_details, :suggestion_id, :user_id
end
