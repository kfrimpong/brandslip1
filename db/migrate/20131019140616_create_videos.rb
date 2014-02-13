class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
        t.string :content_type
        t.integer :size
        t.string :filename
        t.string :title
        t.string :description
        t.string :state
        t.timestamps
      end
  end
end
