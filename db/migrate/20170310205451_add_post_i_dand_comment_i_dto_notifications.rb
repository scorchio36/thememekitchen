class AddPostIDandCommentIDtoNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :from_post_id, :integer
    add_column :notifications, :from_comment_id, :integer
  end
end
