class AddTransactionTable < ActiveRecord::Migration
  def change
  	create_table :transactions do |t|
  		t.integer :transaction_type #debit/credit(0) or payout(1)
  		t.integer :amount
  		t.string :uri
  		t.integer :debitted_id
  		t.integer :creditted_id
  	end
  end
end
