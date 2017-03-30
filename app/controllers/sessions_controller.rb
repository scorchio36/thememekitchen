class SessionsController < ApplicationController

  before_action :if_logged_in_redirect, only:[:new]

  #login form view
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])

    if user && user.authenticate(params[:session][:password])
      #log user in
      log_in(user)

      #check if the user wants to be remembered and use the corresponding method to remember or forget the user
      if params[:session][:remember_me] == '1'
        remember user
      else
        forget user
      end

      redirect_to user
    else
      #handle failure
      flash.now[:danger] = "Invalid Username/Password"
      render 'new' #rerender the page if the login is incorrect
    end

  end

  def destroy

    #if there are multiple browser windows open and the user logs out in one then the current_user function
    #in the SessionsHelper will be nil and the logout function will not work properly (The logout function
    #depends on current_user not being nil). So make sure the user is logged_in before you call log_out
    if logged_in?
      log_out
    end
    redirect_to home_path

  end

  private

  #dont let the user visit the login page if they are already logged in
  def if_logged_in_redirect
    if logged_in?
      redirect_to current_user
    end
  end
end
