module SessionsHelper

  def log_in(user)

    session[:user_id] = user.id

  end

  #remember that local variables are used when you only want the variable within the local scope. If you want to use the
  #data later in another scope, save it in an instance variable
  def current_user

    @current_user = @current_user || User.find_by(id: session[:user_id])

  end

  def logged_in?
    !current_user.nil?
  end

  def log_out

    session.delete(:user_id)
    @current_user = nil

  end

end
