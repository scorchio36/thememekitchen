class StaticPagesController < ApplicationController
  def home
  end

  def buffet

    @all_posts = Post.all
    session[:currentIndex] = @all_posts.count
    @current_post = @all_posts.find_by(id: session[:currentIndex]);
    @poster = User.find_by(id: @current_post.user_id)

    if logged_in?
      @comment = current_user.comments.build
    end
    
    @post_comments = @current_post.comments

  end

  def kitchen
  end

  def handle_next

    @all_posts = Post.all
    session[:currentIndex] = (session[:currentIndex]-1)
    @current_post = @all_posts.find_by(id: session[:currentIndex]);
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    respond_to do |format|
      format.js
    end
  end

  def handle_prev

    @all_posts = Post.all
    session[:currentIndex] = (session[:currentIndex]+1)
    @current_post = @all_posts.find_by(id: session[:currentIndex]);
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    respond_to do |format|
      format.js
    end
  end

  def handle_like

    @current_post = Post.find_by(id: session[:currentIndex])

    if(@current_post.liked_by(current_user))

      @current_post.update_attribute(:likes, (@current_post.likes-1))
      current_user.removeLikedPost(@current_post.id) #remove the post from the current user's liked posts

    else

      @current_post.update_attribute(:likes, (@current_post.likes+1))
      current_user.pushLikedPost(@current_post.id) #add the post to the current_user's liked posts

      if(@current_post.disliked_by(current_user))
        @current_post.update_attribute(:dislikes, (@current_post.dislikes-1))
        current_user.removeDislikedPost(@current_post.id)
      end

    end

    respond_to do |format|

      format.js

    end

  end

  def handle_dislike

    @current_post = Post.find_by(id: session[:currentIndex])

    if(@current_post.disliked_by(current_user))

      @current_post.update_attribute(:dislikes, (@current_post.dislikes-1))
      current_user.removeDislikedPost(@current_post.id) #remove the post from the current user's liked posts

    else

      @current_post.update_attribute(:dislikes, (@current_post.dislikes+1))
      current_user.pushDislikedPost(@current_post.id) #add the post to the current_user's liked posts

      if @current_post.liked_by(current_user)
        @current_post.update_attribute(:likes, (@current_post.likes-1))
        current_user.removeLikedPost(@current_post.id)
      end

    end

    respond_to do |format|

      format.js

    end

  end

end
