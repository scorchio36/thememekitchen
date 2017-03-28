class CommentsController < ApplicationController

  include CommentsHelper

  def new
    #boolean to tell modal to show up or not on a feed to indicate whether an 'empty comment' warning should appear
    #initialize it to false
    session[:comment_blank_error] = false
    @comment = current_user.comments.build
  end

  def create
    @comment = current_user.comments.build(comment_params)
    #I do not want a comment to pass if it is empty. But I also want to be able to assign a post_id to the comment.
    #Adding an arbitrary post id of 1 initially allows me to run a save test on the comment to see if it is blank.
    #If it is not blank, then it will pass the if test and within the if block I will find the real post and assign it to
    #the comment.
    @comment.update_attribute(:post_id, 1)

    if @comment.save

      @current_post = Post.find_by(id: session[:current_post_id])
      @comment.update_attribute(:post_id, @current_post.id)

      #notify the owner of the current post that someone has commented on their post
      @current_post.user.notifications.create(description:"commented on your post", from_user_id: current_user.id,
                                                        from_post_id: @current_post.id, from_comment_id: @comment.id)
      respond_to do |format|
        format.js
      end

      #keep it false if everything works out - otherwise change the variable to true and warn the user
      session[:comment_blank_error] = false

    else
      session[:comment_blank_error] = true
      redirect_to :back #this just reloads the page so that the javascript modal can appear
    end
  end

  def destroy

    @comment = Comment.find_by(id: params[:id])
    @post_comments = @comment.post.comments #used to rerender all of the comments for ajax rerender
    @poster = @comment.post.user #used to rerender all of the comments with ajax
    Notification.where(from_comment_id: @comment.id).each do |notification| #need to destroy a notificaiton associated with this comment if the comment is deleted
      notification.destroy
    end

    @comment.destroy

    #rerenders the comments on a destroy
    respond_to do |format|
      format.js { render :file => 'comments/handle_like_dislike.js.erb' }
    end

  end

  def handle_like

    @comment = Comment.find_by(id: params[:comment_id])
    @current_post = @comment.post
    @post_comments = @current_post.comments
    @poster = @current_post.user

    like_logic

    #comment needs to be updated with ajax when liked/disliked
    respond_to do |format|
      format.js { render :file => 'comments/handle_like_dislike.js.erb' }
    end
  end

  def handle_dislike

    @comment = Comment.find_by(id: params[:comment_id])
    @current_post = @comment.post
    @post_comments = @current_post.comments
    @poster = @current_post.user

    dislike_logic

    respond_to do |format|
      format.js { render :file => 'comments/handle_like_dislike.js.erb' }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
