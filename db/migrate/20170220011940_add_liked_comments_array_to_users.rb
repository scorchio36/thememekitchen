class AddLikedCommentsArrayToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :liked_comments, :integer, array: true, default: []
    add_column :users, :disliked_comments, :integer, array: true, default: []
  end
end
