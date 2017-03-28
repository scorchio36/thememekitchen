class MainCoursesController < ApplicationController

  #this controller is for the main course feature feed
  #this controller may also have a bottlecap as it scales which is in the search query at the beginning of each next
  #and prev function. I will be keeping an eye on that
  include MainCoursesHelper

  before_action :post_like_dislike_filter, only: [:handle_like, :handle_dislike]

  #home page action renders all the main course posts
  def home
    init_home
  end

  def handle_next

    init_next

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

    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = @current_post.user

    like_logic

    @poster.notifications.create(description:"liked your post", from_user_id: current_user.id, from_post_id: @current_post.id)

    respond_to do |format|
      format.js { render :file => 'main_courses/handle_like_dislike.js.erb' }
    end

  end

  def handle_dislike

    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = @current_post.user

    dislike_logic

    respond_to do |format|
      format.js { render :file => 'main_courses/handle_like_dislike.js.erb' }
    end

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
