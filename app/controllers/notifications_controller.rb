# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate notifications. 
# Notifications are fired in response to actions such as
# a friend/group request or a comment on your kite
class NotificationsController < ApplicationController

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
  
   
  # Delete a notification
  def destroy
    @Notification = Notification.find(params[:id])
        
    respond_to do |format| 
      if @Notification && @Notification.destroy
        format.html { redirect_to(Kites, :notice => 'Kite has been unfollowed.')}
        format.xml  { render :xml => "", :status => :deleted, :location => Kites }
        format.js {}
        format.json { render :json => @Notification, :status => :success }
      else  
        format.html { render :action => Kites }
        format.xml  { render :status => :failure }
        format.js {}
        format.json { render :status => :unprocessable_entity }
      end
    end
  end
end
