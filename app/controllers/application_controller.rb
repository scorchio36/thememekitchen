class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello_test
    render text: "Hello"
  end
end
