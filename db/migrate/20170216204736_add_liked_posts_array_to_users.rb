class AddLikedPostsArrayToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :liked_posts, :integer, array: true, default: []
    add_column :users, :disliked_posts, :integer, array: true, default: []
  end
end
