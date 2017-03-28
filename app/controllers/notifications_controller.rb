class NotificationsController < ApplicationController

  #paginate the User's notifications and show them on this page
  def notification_list
    @user = User.find(params[:id])
    @notifications = @user.notifications.paginate(page: params[:page], per_page: 15)
    #when the users see their notifications, we should swap the model variable :seen from false to true
    @user.notifications.where(seen: false).each do |n|
      n.update_attribute(:seen, true)
    end
  end

  def destroy
    @notification = Notification.find_by(id: params[:notification_id])
    @notification.delete

    #these two variables are used by the destroy.js.erb to be able to rerender the partial
    @user = User.find(params[:id])
    @notifications = @user.notifications.paginate(page: params[:page], per_page: 15)

    #this will allow the user to remove notifications with AJAX
    respond_to do |format|
      format.js
    end

  end
end
