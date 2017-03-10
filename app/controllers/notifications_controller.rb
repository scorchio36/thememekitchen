class NotificationsController < ApplicationController

  def notification_list
    @user = User.find(params[:user_id])
    @notifications = @user.notifications
  end
end
