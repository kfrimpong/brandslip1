class CreateContactUs < ActiveRecord::Migration
  def change
    create_table :contact_us do |t|
      t.string :name
      t.string :email
      t.string :company_name
      t.string :location
      t.string :phone_no
      t.text :message

      t.timestamps
    end
  end
end
