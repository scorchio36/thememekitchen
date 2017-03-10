class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :description
      t.references :user, foreign_key: true
      t.integer :from_user_id #this is an optional value that can tell you if another user did something to your post
      t.boolean :seen, default: false

      t.timestamps
    end
  end
end
