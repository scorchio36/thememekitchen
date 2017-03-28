module StaticPagesHelper

  def init_buffet
    #I am not sure how scalable this controller action is. I will be checking back into it periodically as the number
    #of posts increases.
    @current_post = Post.first #always get the latest post from the buffet
    @all_posts = Post.all
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    #keep in mind that this current index is kept within a cookie - Each user will have an individual experience
    #and this variable will be undefined by nonsynchronous edits. Each user has his/her own curent index.
    session[:currentIndex] = @all_posts.index(@current_post) #store the current index for later use
    session[:current_post_id] = @current_post.id

    #build a new comment to allow the logged in user to write a new comment if they want to
    if logged_in?
      @comment = current_user.comments.build
    end
  end

  def init_next
    @all_posts = Post.all
    session[:currentIndex] = (session[:currentIndex]+1) #update the current index to the next index
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id
  end

  def init_prev
    @all_posts = Post.all
    (session[:currentIndex] = (session[:currentIndex]-1)) unless (session[:currentIndex] == 0) #update current index to previous unless we are already at 0
    @current_post = @all_posts[session[:currentIndex]]
    @poster = User.find_by(id: @current_post.user_id)
    @post_comments = @current_post.comments

    session[:current_post_id] = @current_post.id
  end
end
