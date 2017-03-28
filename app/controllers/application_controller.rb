class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #SessionsHelper contains functions related to user sessions which will be used by all of our classes.
  #Include it here so it can be used by other classes
  include SessionsHelper
  include SharedHelper

  #ADMIN FUNCTION
  #Allows an admin to add a post to the main course - used by StaticPages and Users controller
  def handle_main_course
    @current_post = Post.find(session[:current_post_id])
    @current_post.toggle_main_course #main course is a boolean

    @poster = @current_post.user
    #notify the poster that their post has been added to the main_course post feed
    @poster.notifications.create(description: "Your post has been added to the main course menu!!! Congratulations!",
                                                                                          from_post_id: @current_post.id)
    respond_to do |format|
      format.js { render :file => 'shared/handle_main_course.js.erb' }
    end
  end

end
