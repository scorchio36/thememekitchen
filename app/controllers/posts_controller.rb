class PostsController < ApplicationController

  before_action :user_must_be_logged_in, only: [:new, :create]
  before_action :must_be_current_users_page_to_destroy_post, only: [:destroy]
  before_action :redirect_index_to_kitchen, only: [:index] #this is needed to fix some weird glitch with naming kitchen and new post path


  def new
    @post = current_user.posts.build
    #Modal to say whether user has successfully created a new post - should be intialized to false so it doesnt appear
    #every time the profile page opens
    session[:show_new_post_dialog] = false
  end

  def create
      @post = current_user.posts.build(post_params)

      if @post.save
        #handle success
        session[:show_new_post_dialog] = true #this will make the modal show up on the user profile page
        redirect_to current_user
      else
        #handle error
        render 'new' #rerender the page if there is an error
      end

  end

  def destroy

    @post = Post.find_by(id: params[:post_id]) #destroy button will send the post we want to destroy through params[:post_id]
    @user = @post.user
    @posts = @user.posts #store the posts so that the destroy.js.erb file can render the rest of the posts properly
    #(if you delete the post first then there will be complications with rerendering)

    #make sure you destroy any notifications related to any destroyed posts so we do not get any nil errors later
    Notification.where(from_post_id: @post.id).each do |notification|
      notification.destroy
    end

    @post.destroy

    #The post should be destroyed with ajax on the user page
    respond_to do |format|
      format.js
    end

  end

  def index
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :picture)
  end

  #don't let a user make a new post if they are not logged in
  def user_must_be_logged_in

    unless logged_in?
      flash[:danger] = "Please log in"
      redirect_to login_path
    end

  end
end

#protect other posts from being destroyed by somone not logged in or other users who do not own the posts
def must_be_current_users_page_to_destroy_post

    unless (Post.find_by(id: params[:post_id]).user.id == current_user.id)
      flash[:danger] = "This is not your profile page. Please log in if this is your account"
      redirect_to home_path
    end
end

#There was a problem with reloading the page after a submit returns an error - this just fixes that bug by redirecting
#the index to the kitchen path
def redirect_index_to_kitchen

  redirect_to kitchen_path

end
