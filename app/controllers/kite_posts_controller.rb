class KitePostsController < ApplicationController
  
  def new
    @kitePost = Comment.new
    @kite = Kite.find(params[:kite])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @kitePost }
    end
  end
  
  def create
    @kitePost = KitePost.new(params["kite_post"])
    @kitePost.kite = Kite.find(params[:kite_post][:kite_id])    
    @kitePost.tag = @kitePost.text.scan(HASHTAG_REGEX).join(",")
    targetUsers = @kitePost.text.scan(USERTAG_REGEX).join(",")
    
    # Notify all subscribers
    @kitePost.kite.followers.each do |member|
      send_kite_post_update_notification("One of the kites that you follow has been updated.", 
        @kitePost.kite, member)
    end
    
    # Notify anyone who has been specifically mentioned as well
    targetUsers.each do |tu|
      user = User.first(:username => tu..strip[1..-1])
      send_kite_update_notification("Someone has mentioned you in their kite status.", @kitePost.kite, user)
    end
          
    respond_to do |format|
      if @kitePost.save()
        format.html { redirect_to(@kitePost.kite, :notice => "Post was created successfully") }
        format.xml  { render :xml => @kitePost, :status => :created, :location => @kitePost }
        format.js {}
        format.json { render :json => @kitePost, :status => :created}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kitePost.errors, :status => :unprocessable_entity }
        format.js {}
        format.json { render :json => @kitePost.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @kitePost = KitePost.find(params[:id])
  end

  def delete
    @kitePost = Kite.find(params[:id])
          
    if @kitePost.kite.user.id == current_user.id
      @kitePost.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(Kite) }
      format.xml  { head :ok }
    end
  end
  
  def index

    @kitePosts = KitePost.all(:order => "CreateDate DESC").paginate(:page => params[:page], :per_page => 30)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @kitePosts }
      format.js {}
      format.json { render :json => {:KitePosts => @kitePosts, status => :ok}}
    end
  end
  
  def show
    @kitePost = KitePost.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @kitePost }
    end
  end
  
  private
  def send_kite_post_update_notification(message, kite, user)
    @notification = Notification.new(
      :message => message,
      :user => user,
      :link => kite_url(kite)) 
    if user && kite.user.sendEmailNotifications
      NotificationMailer.notification_email(@notification).deliver
    end    
    @notification.save
  end
end
