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


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
  end

end
