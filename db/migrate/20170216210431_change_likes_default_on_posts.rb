class ChangeLikesDefaultOnPosts < ActiveRecord::Migration[5.0]
  def change

    change_column_default(:posts, :likes, 0)
    change_column_default(:posts, :dislikes, 0)

  end
end
