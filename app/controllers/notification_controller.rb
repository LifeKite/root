class NotificationController < ApplicationController

  def new 
    @Notification = Notification.new
    respond_to do |format|
      format.html
    format.xml {render :xml => @Notification}
    end
  end
  
  def create
    @Notification = Notification.new(params[:note])
    @Notification.state = "new";
    
    respond_to do |format| 
      format.html { render :action => "new" }
      format.xml  { render :xml => @Notification.errors, :status => :created }
    end
  end
  
  def markViewed
    @Notification = Notification.find(params[:id])
    @Notification.markViewed
    
    respond_to do |format|
      format.html {redirect_to(current_user) }
      format.xml {head :ok }
    end
  end
  
  def destroy
    @Notification = Notification.find(params[:id])
    @Notification.destroy
    
    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
end
