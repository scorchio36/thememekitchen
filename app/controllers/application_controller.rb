class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #SessionsHelper contains functions related to user sessions which will be used by all of our classes.
  #Include it here so it can be used by other classes
  include SessionsHelper

end
