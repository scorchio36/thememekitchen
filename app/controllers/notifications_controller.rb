class NotificationsController < ApplicationController

  def notification_list
    @user = User.find(params[:id])
    @notifications = @user.notifications
    @user.notifications.where(seen: false).each do |n|
      n.update_attribute(:seen, true)
    end
  end

  def destroy
    #these two variables are used by the destroy.js.erb to be able to rerender the partial
    @user = User.find(params[:id])
    @notifications = @user.notifications

    @notification = Notification.find_by(id: params[:notification_id])
    @notification.delete

    respond_to do |format|

      format.js

    end
  end
end
