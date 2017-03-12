class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  def hello_test
    render text: "Hello"
  end

end
