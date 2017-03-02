class PostsController < ApplicationController

  before_action :user_must_be_logged_in, only: [:new, :create]
  before_action :must_be_current_users_page_to_destroy_post, only: [:destroy]

  def new
    @post = current_user.posts.build
  end

  def create
      @post = current_user.posts.build(post_params)

      if @post.save

        #handle success
        flash[:success] = "Nice post you dank memer!"
        redirect_to current_user

      else

        #handle error
        render 'new'
      end

  end

  def destroy

    @post = Post.find_by(id: params[:post_id])
    @user = @post.user
    @posts = @user.posts #store the posts so that the destroy.js.erb file can render the rest of the posts properly
    @post.destroy


    respond_to do |format|
      format.js
    end

  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :picture)
  end

  def user_must_be_logged_in

    unless logged_in?
      flash[:danger] = "Please log in"
      redirect_to login_path
    end

  end
end

def must_be_current_users_page_to_destroy_post

    unless (Post.find_by(id: params[:post_id]).user.id == current_user.id)
      flash[:danger] = "This is not your profile page. Please log in if this is your account"
      redirect_to home_path
    end
end
