class CommentsController < ApplicationController

  def new
    @comment = current_user.comments.build
  end

  def create

    @comment = current_user.comments.build(comment_params)
    @current_post = Post.find_by(id: session[:current_post_id])
    @comment.update_attribute(:post_id, @current_post.id)

    @comment.save

    respond_to do |format|

      format.js

    end


  end

  def handle_like

    @comment = Comment.find_by(id: params[:comment_id])
    @current_post = @comment.post
    @post_comments = @current_post.comments
    @poster = @current_post.user

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

    end

    respond_to do |format|

      format.js { render :file => 'comments/handle_like_dislike.js.erb' }

    end
  end

  def handle_dislike

    @comment = Comment.find_by(id: params[:comment_id])
    @current_post = @comment.post
    @post_comments = @current_post.comments
    @poster = @current_post.user

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

    respond_to do |format|

      format.js { render :file => 'comments/handle_like_dislike.js.erb' }

    end
  end

  private

  def comment_params

    params.require(:comment).permit(:comment)

  end
end
