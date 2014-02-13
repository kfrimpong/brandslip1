class AddBalancedCustomerUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balanced_customer_uri, :string
  end
end
