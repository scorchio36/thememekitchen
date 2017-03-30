class UsersController < ApplicationController

  include UsersHelper

  before_action :post_like_dislike_filter, only: [:handle_post_like, :handle_post_dislike]
  before_action :prevent_other_user_edits, only: [:edit, :edit_password]
  before_action :if_logged_in_redirect, only:[:new]

  #User profile page will show information about user and their posts
  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts
  end

  def new
    @user = User.new

    #This is a session variable that tells us whether or not the 'Thanks for signing up modal' should appear on the user profile screen
    #I initialize it to false here and when they user is created it will be switched to true until the user clicks out
    session[:show_signup_message] = false
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def create

    @user = User.new(user_params)

    if @user.save

      #handle success
      log_in(@user) #store the user_id as the current_user id
      session[:show_signup_message] = true #show the signup message
      redirect_to @user #redirect user to his/her profile page

    else

      #handle error
      #rerender the page if the system detects an error. The corresponding view will display the errors
      render 'new'
      session[:show_signup_message] = false #make sure the modal stays false

    end
  end

  def update

    @user = User.find(params[:id])

    #In this method, each corresponding user attribute can be change depending on which submit button is pressed on the edit page
    if(params[:change_username])

      if @user.update_attributes(user_params)
        session[:show_username_changed] = true #another modal to confirm that a username update happened
        redirect_to @user
      else
        render 'edit' #if we get an error then rerender the page
      end

    end
    #each method changer in this update method is structured in the same manner as this change_username block

    if(params[:change_email])

      if @user.update_attributes(user_params)
        session[:show_email_changed] = true
        redirect_to @user
      else
        render 'edit'
      end
    end

    #edit_password is a different page from the edit page where you can update your password
    if(params[:change_password])
      if params[:user][:password].empty? #include an empty password check
        flash[:danger] = "Password fields are empty"
        render 'edit_password'
      else
        if @user.update_attributes(user_params)
          if @user.update_attributes(user_params)
            session[:show_password_changed] = true
            redirect_to @user
          else
            render 'edit_password'
          end
        else
          render 'edit_password'
        end
      end
    end

    if(!(params[:change_picture].nil?))

      if @user.update_attribute(:picture, params[:user][:picture])
        flash[:success] = "Profile Picture successfully updated"
        redirect_to @user
      else
        render 'edit'
      end
    end

  end

  def edit_password #separate page to let user update his/her password

    @user = User.find(params[:id])

  end

  #This is the feed for each individual user's posts (Click on a thumbnail in a user profile and this feed is what will appear)
  def posts_feed

    init_posts_feed

  end

  #When the user presses the next arrow button, the next post from the user's profile will appear on the screen
  def handle_next

    init_next

    respond_to do |format|

      format.js { render :file => 'shared/handle_next_prev.js.erb' }

    end

  end

  #When the user presses the previous arrow button, the previous post from the user's profile will appear on the screen
  def handle_prev

    init_prev

    respond_to do |format|

      format.js { render :file => 'shared/handle_next_prev.js.erb' }

    end

  end

  def handle_post_like

    #used by the like_logic function
    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
    @current_post = @all_posts[session[:currentIndex]]

    like_logic

    #notify the poster that their post was liked
    @poster.notifications.create(description:"liked your post", from_user_id: current_user.id, from_post_id: @current_post.id)

    #Use AJAX to update the like button
    respond_to do |format|
      format.js {render :file => 'users/handle_post_like_dislike.js.erb'}
    end

  end


  def handle_post_dislike

    @poster = User.find(params[:user_id])
    @all_posts = @poster.posts
    @current_post = @all_posts[session[:currentIndex]]

    dislike_logic

    #Use AJAX to update the dislike button
    respond_to do |format|
      format.js {render :file => 'users/handle_post_like_dislike.js.erb'}
    end

  end


  #users can subscribe to other users
  def handle_subscribe

    @user = User.find(params[:user_id])
    current_user.follow(@user)

    #update the subscribe button using AJAX
    respond_to do |format|
      format.js { render :file => 'users/handle_sub_unsub.js.erb' }
    end

    #notify the user when someone subscribes to them
    @user.notifications.create(description:"has subscribed to your memes!", from_user_id: current_user.id)

  end

  def handle_unsubscribe

    @user = User.find(params[:user_id])
    current_user.unfollow(@user)

    respond_to do |format|
      format.js { render :file => 'users/handle_sub_unsub.js.erb' }
    end

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
  end

  #Just a filter to keep non-logged-in people from liking a post
  def post_like_dislike_filter

    unless logged_in?
      redirect_to login_path
      flash[:danger] = "You must be logged in to like/dislike a post"
    end

  end

  #protect edit pages - keep anyone out who isnt the owner of the edit page
  def prevent_other_user_edits
    @user = User.find(params[:id])

    if !(logged_in?)
      redirect_to login_path
      flash[:danger] = "You must be logged in to visit this page"

    else
      if (current_user.id != @user.id)
        redirect_to home_path
        flash[:danger] = "You must be logged in as the correct user to visit this page"
      end
    end
  end

  #dont let the user visit the signup page if they are already logged in
  def if_logged_in_redirect
    if logged_in?
      redirect_to current_user
    end
  end

end
