class AddLikedPostToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :liked_posts, :text, array: true, default: []
    add_column :users, :disliked_posts, :text, array: true, default: [] 
  end
end
