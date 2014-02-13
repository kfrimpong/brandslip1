class CreateBrandslipSuggestions < ActiveRecord::Migration
  def change
    create_table :brandslip_suggestions do |t|
      t.string :title
      t.text :description
      t.integer :category
      t.integer :sub_category
      t.decimal :price, :precision => 7, :scale => 2
      t.string :valid_for
      t.date :start_date
      t.integer :user_id
      t.string :crowd_size
      t.time :time
      t.string :proof_selector
      t.string :city
      t.string :state
      t.integer :is_assigned
      t.integer :assigned_to
      t.text :comment
      t.integer :is_mark_done
      t.string :video
      t.string :online_media_source
      t.string :followers_subscribers
      t.integer :suggestion_type
      t.integer :is_reviewed

      t.timestamps
    end
  end
end
