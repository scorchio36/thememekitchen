class NotificationsController < ApplicationController

  def notification_list
    @user = User.find(params[:id])
    @notifications = @user.notifications
  end
end
