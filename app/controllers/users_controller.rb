class UsersController < ApplicationController


  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def create

    @user = User.new(user_params)

    if @user.save

      #handle success
      log_in(@user)
      flash[:success] = "Thank you for signing up!"
      redirect_to @user

    else

      #handle error
      render 'new'

    end
  end

  def update

    @user = User.find_by(id: params[:id])


    if @user.update_attribute(:picture, params[:user][:picture])
      redirect_to @user
    end

  end

  def posts_feed

    @poster = User.find(params[:id])
    @all_posts = @poster.posts
    @current_post = Post.find_by(id: params[:post_id])
    session[:currentIndex] = @all_posts.index(@current_post)
    if logged_in?
      @comment = current_user.comments.build
    end

    @post_comments = @current_post.comments

  end

  def handle_next

    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
    session[:currentIndex] = session[:currentIndex]+1
    @current_post = @all_posts[session[:currentIndex]]
    @post_comments = @current_post.comments

    respond_to do |format|

      format.js { render :file => 'users/handle_next_prev.js.erb' }

    end

  end

  def handle_prev

    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
    (session[:currentIndex] = session[:currentIndex]-1) unless (session[:currentIndex] == 0)
    @current_post = @all_posts[session[:currentIndex]]
    @post_comments = @current_post.comments

    respond_to do |format|

      format.js { render :file => 'users/handle_next_prev.js.erb' }

    end

  end

  def handle_post_like

    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
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

      format.js {render :file => 'users/handle_post_like_dislike.js.erb'}

    end

  end


  def handle_post_dislike

    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
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

      format.js {render :file => 'users/handle_post_like_dislike.js.erb'}

    end

  end

  def handle_comment_like

    #need current post to get the current comments which we need for the js-erb page

    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
    @current_post = @all_posts[session[:currentIndex]]
    @post_comments = @current_post.comments

    @comment = Comment.find_by(id: params[:comment_id])

    if(@comment.liked_by(current_user))

      @comment.update_attribute(:likes, (@comment.likes-1))
      current_user.removeLikedComment(@comment.id) #remove the comment from the current user's liked comments

    else

      @comment.update_attribute(:likes, (@comment.likes+1))
      current_user.pushLikedComment(@comment.id) #add the comment to the current_user's liked comments

      if(@comment.disliked_by(current_user))
        @comment.update_attribute(:dislikes, (@comment.dislikes-1))
        current_user.removeDislikedComment(@comment.id)
      end

    end

    respond_to do |format|

      format.js { render :file => 'users/handle_comment_like_dislike.js.erb' }

    end
  end


  def handle_comment_dislike

    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
    @current_post = @all_posts[session[:currentIndex]]
    @post_comments = @current_post.comments

    @comment = Comment.find_by(id: params[:comment_id])

    if(@comment.disliked_by(current_user))

      @comment.update_attribute(:dislikes, (@comment.dislikes-1))
      current_user.removeDislikedComment(@comment.id) #remove the comment from the current user's liked comments

    else

      @comment.update_attribute(:dislikes, (@comment.dislikes+1))
      current_user.pushDislikedComment(@comment.id) #add the comment to the current_user's liked comments

      if(@comment.liked_by(current_user))
        @comment.update_attribute(:likes, (@comment.likes-1))
        current_user.removeLikedComment(@comment.id)
      end

    end

    respond_to do |format|

      format.js { render :file => 'users/handle_comment_like_dislike.js.erb' }

    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
  end

end
