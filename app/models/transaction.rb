class Transaction < ActiveRecord::Base
	attr_accessible :transaction_type, :amount, :uri, :debitted_id, :creditted_id
end