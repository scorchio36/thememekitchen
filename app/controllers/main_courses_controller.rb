class MainCoursesController < ApplicationController

  before_action :post_like_dislike_filter, only: [:handle_like, :handle_dislike]

  def home

    #reorder has to be used because default scope will not allow the order function to override the order
    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    @current_post = @all_posts[0]

    session[:currentIndex] = @all_posts.index(@current_post)
    @poster = User.find_by(id: @current_post.user_id)

    session[:current_post_id] = @current_post.id

    if logged_in?
      @comment = current_user.comments.build
    end

    @post_comments = @current_post.comments

  end

  def handle_next

    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    session[:currentIndex] = (session[:currentIndex]+1)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id

    respond_to do |format|
      format.js { render :file => 'shared/handle_next_prev.js.erb' }
    end
  end

  def handle_prev

    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    (session[:currentIndex] = (session[:currentIndex]-1)) unless (session[:currentIndex] == 0)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id

    respond_to do |format|
      format.js { render :file => 'shared/handle_next_prev.js.erb' }
    end
  end

  def handle_like

    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = @current_post.user

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

    @poster.notifications.create(description:"liked your post", from_user_id: current_user.id, from_post_id: @current_post.id)

    respond_to do |format|

      format.js { render :file => 'main_courses/handle_like_dislike.js.erb' }

    end

  end

  def handle_dislike

    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
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
