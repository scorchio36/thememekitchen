class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end

    #im going to find users by id and the time of their creation
    add_index :posts, [:user_id, :created_at]
  end
end
