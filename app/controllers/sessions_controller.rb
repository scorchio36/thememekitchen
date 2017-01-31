class SessionsController < ApplicationController
  def new
  end

  def create

    user = User.find_by(name: params[:session][:name])

    if user && user.authenticate(params[:session][:password])

      #log user in
      log_in(user)
      redirect_to user

    else

      #handle failure
      flash.now[:danger] = "Invalid Username/Password"
      render 'new'
    end

  end

  def destroy

    log_out
    redirect_to home_path

  end
end
