class StaticPagesController < ApplicationController

  before_action :post_like_dislike_filter, only: [:handle_like, :handle_dislike]

  def buffet

    @current_post = Post.first #always get the latest post from the buffet
    @all_posts = Post.all
    session[:currentIndex] = @all_posts.index(@current_post)
    @poster = User.find_by(id: @current_post.user_id)

    session[:current_post_id] = @current_post.id

    if logged_in?
      @comment = current_user.comments.build
    end

    @post_comments = @current_post.comments

  end

  def kitchen
  end

  def handle_next

    @all_posts = Post.all
    session[:currentIndex] = (session[:currentIndex]+1)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id

    respond_to do |format|
      format.js { render :file => 'static_pages/handle_next_prev.js.erb' }
    end
  end

  def handle_prev

    @all_posts = Post.all
    (session[:currentIndex] = (session[:currentIndex]-1)) unless (session[:currentIndex] == 0)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id

    respond_to do |format|
      format.js { render :file => 'static_pages/handle_next_prev.js.erb' }
    end
  end

  def handle_like

    @all_posts = Post.all
    @current_post = @all_posts[session[:currentIndex]]

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

    @all_posts = Post.all
    @current_post = @all_posts[session[:currentIndex]]

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

  #admin function
  def handle_main_course

    @current_post = Post.find(session[:current_post_id])

    @current_post.toggle_main_course

    respond_to do |format|

      format.js { render :file => 'shared/handle_main_course.js.erb' }

    end

  end





  def personal_chefs
    @subscriptions = current_user.following
  end

  def subscribers
    @user = User.find(params[:user_id])
    @subscribers = @user.followers
  end


  private

  #Just a filter to keep non-logged-in people from liking a post
  def post_like_dislike_filter

    unless logged_in?
      redirect_to login_path
      flash[:danger] = "You must be logged in to like/dislike a post"
    end

  end


end
