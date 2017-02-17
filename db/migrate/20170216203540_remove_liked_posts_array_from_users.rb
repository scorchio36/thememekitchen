class RemoveLikedPostsArrayFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :liked_posts
    remove_column :users, :disliked_posts
  end
end
