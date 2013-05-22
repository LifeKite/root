# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate notifications. 
# Notifications are fired in response to actions such as
# a friend/group request or a comment on your kite
class NotificationController < ApplicationController

  # Create a new notification
  def new 
    @Notification = Notification.new
    respond_to do |format|
      format.html
    format.xml {render :xml => @Notification}
    end
  end
  
  # Persist a new notification
  def create
    @Notification = Notification.new(params[:note])
    @Notification.state = "new";
    
    respond_to do |format| 
      format.html { render :action => "new" }
      format.xml  { render :xml => @Notification.errors, :status => :created }
    end
  end
  
  # Mark a notification as having been viewed
  def markViewed
    @Notification = Notification.find(params[:id])
    @Notification.markViewed
    
    respond_to do |format|
      format.html {redirect_to(current_user) }
      format.xml {head :ok }
    end
  end
  
  # Delete a notification
  def destroy
    @Notification = Notification.find(params[:id])
    @Notification.destroy
    
    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
end
