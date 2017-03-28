module CommentsHelper

  def like_logic
    if(@comment.liked_by(current_user))

      @comment.update_attribute(:likes, (@comment.likes-1))
      current_user.removeLikedComment(@comment.id) #remove the comment from the current user's liked comments

    else

      @comment.update_attribute(:likes, (@comment.likes+1))
      current_user.pushLikedComment(@comment.id) #add the comment to the current_user's liked comments

      if(@comment.disliked_by(current_user))
        @comment.update_attribute(:dislikes, (@comment.dislikes-1))
        current_user.removeDislikedComment(@comment.id)
      end

      @comment.user.notifications.create(description:"liked your comment on this post", from_user_id: current_user.id, from_post_id: @current_post.id)

    end
  end

  def dislike_logic
    if(@comment.disliked_by(current_user))

      @comment.update_attribute(:dislikes, (@comment.dislikes-1))
      current_user.removeDislikedComment(@comment.id) #remove the comment from the current user's liked comments

    else

      @comment.update_attribute(:dislikes, (@comment.dislikes+1))
      current_user.pushDislikedComment(@comment.id) #add the comment to the current_user's liked comments

      if(@comment.liked_by(current_user))
        @comment.update_attribute(:likes, (@comment.likes-1))
        current_user.removeLikedComment(@comment.id)
      end

    end
  end
end
