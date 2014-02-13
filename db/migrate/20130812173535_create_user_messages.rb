class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.integer :from_user
      t.integer :to_user
      t.string :message_title
      t.text :message_body

      t.timestamps
    end
  end
end
