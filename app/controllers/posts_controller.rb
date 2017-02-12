class PostsController < ApplicationController

  before_action :user_must_be_logged_in, only: [:new, :create]

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
