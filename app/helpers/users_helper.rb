#module to help clean up the UsersController class
module UsersHelper

  #used with posts_feed method
  def init_posts_feed
    #Clicking on the user profile thumbnail picture will send a post_id which we will use to find and enlarge which post was clicked.
    #We use this to get the rest of the information we need to display the post, and the corresponding poster and comments.
    @current_post = Post.find_by(id: params[:post_id])
    @poster = @current_post.user
    @all_posts = @poster.posts
    @post_comments = @current_post.comments

    #I store the currentIndex of the post in a session so that the next and previous methods can know which post to go to next
    session[:currentIndex] = @all_posts.index(@current_post)

    #if the user is logged in then build a new comment that the user can use to write a new comment
    if logged_in?
      @comment = current_user.comments.build
    end

    #keeping the current_post id stored is useful if I end up needing it later
    #like in the handle_main_course function
    session[:current_post_id] = @current_post.id

  end

  #used with handle_next user function
  def init_next

    #When the next button is pressed we need to get the user id passed in through a custmo params variable because params[:id]
    #will not work.
    @poster = User.find(params[:user_id])
    #I use the session[:currentIndex] variable as an index into an array of user posts found in all_posts
    @all_posts = @poster.posts
    session[:currentIndex] = session[:currentIndex]+1 #increase the current index by 1 to get the 'next' post
    @current_post = @all_posts[session[:currentIndex]]
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id

  end

  #used with handle_prev user function
  def init_prev
    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
    (session[:currentIndex] = session[:currentIndex]-1) unless (session[:currentIndex] == 0) #dont go into negative index
    @current_post = @all_posts[session[:currentIndex]]
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id

  end

end
