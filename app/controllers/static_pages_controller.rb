class StaticPagesController < ApplicationController

  include StaticPagesHelper

  before_action :post_like_dislike_filter, only: [:handle_like, :handle_dislike]

  #buffet contains every post contained by every user in a constant stream - constantly updating
  #Everything for the buffet feed should be initialized here
  def buffet
    init_buffet
  end

  def handle_next

    init_next

    #handle the next arrow using AJAX
    respond_to do |format|
      format.js { render :file => 'shared/handle_next_prev.js.erb' }
    end
  end

  def handle_prev

    init_prev

    respond_to do |format|
      format.js { render :file => 'shared/handle_next_prev.js.erb' }
    end
  end

  def handle_like

    @all_posts = Post.all
    @current_post = @all_posts[session[:currentIndex]]
    @poster = @current_post.user

    like_logic

    #notify poster that someone liked their post
    @poster.notifications.create(description:"liked your post", from_user_id: current_user.id, from_post_id: @current_post.id)

    respond_to do |format|
      format.js
    end

  end

  def handle_dislike

    @all_posts = Post.all
    @current_post = @all_posts[session[:currentIndex]]

    dislike_logic

    respond_to do |format|
      format.js

    end

  end

  #This page displays all the people that the current user is currently subscribed to
  def personal_chefs
    @subscriptions = current_user.following
  end

  #This page displays what users are currently subscribed to the current_user
  def subscribers
    @user = User.find(params[:user_id])
    @subscribers = @user.followers
  end

  #This page will remain inactive until a certain amount of users are reached
  def bar
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
