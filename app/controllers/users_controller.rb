class UsersController < ApplicationController


  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts
  end

  def new
    @user = User.new
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




  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
  end

end
