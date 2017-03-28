module MainCoursesHelper

  def init_home
    #reorder has to be used because default scope will not allow the order function to override the order
    #This sets the order to allow for the latest main_course posts to be shown
    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    @current_post = @all_posts[0]

    session[:currentIndex] = @all_posts.index(@current_post)
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id

    if logged_in?
      @comment = current_user.comments.build
    end
  end

  def init_next
    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    session[:currentIndex] = (session[:currentIndex]+1)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id
  end

  def init_prev
    @all_posts = Post.reorder(main_course_added_at: :desc).where(main_course: true)
    (session[:currentIndex] = (session[:currentIndex]-1)) unless (session[:currentIndex] == 0)
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id
  end
end
