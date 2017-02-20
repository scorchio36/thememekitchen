class CommentsController < ApplicationController

  def new
    @comment = current_user.comments.build
  end

  def create

    @comment = current_user.comments.build(comment_params)
    @current_post = Post.find_by(id: session[:currentIndex])

    @comment.update_attribute(:post_id, @current_post.id)

    @comment.save
    
    respond_to do |format|

      format.js

    end


  end

  private

  def comment_params

    params.require(:comment).permit(:comment)

  end
end
