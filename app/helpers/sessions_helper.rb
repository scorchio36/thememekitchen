module SessionsHelper

  def log_in(user)

    session[:user_id] = user.id

  end

  #remember that local variables are used when you only want the variable within the local scope. If you want to use the
  #data later in another scope, save it in an instance variable

  #if sessions is not nil, then the user has not left the browser. If it is, then check the cookies to see if the user
  #wanted to be remembered and relog them in
  def current_user

    if session[:user_id]

      @current_user ||= User.find_by(id: session[:user_id])

    elsif cookies.signed[:user_id]

      user = User.find_by(id: cookies.signed[:user_id])

      if user && user.authenticate_token(cookies[:remember_token])

        log_in(user)
        @current_user = user

      end

    end


  end

  def logged_in?
    !current_user.nil?
  end

  def log_out

    forget(current_user)
    session.delete(:user_id)
    @current_user = nil

  end

  #Assign the user a new remember_token, hash it and store it in the DB(user.remember). Then take that unhashed token
  #and store it in the user's browser with cookies. You can then get the data from the cookies, authenticate the user
  #with the user.id and remember_token "password" in order to log the user back in
  def remember(user)

    #give user the token and put the hashed remember_token in the db
    user.remember

    #store the token and user id into the browser cookies for later retrieval
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent.signed[:user_id] = user.id

  end

  def forget(user)

    user.forget

    cookies.delete(:user_id)
    cookies.delete(:remember_token)

  end

end
