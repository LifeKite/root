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

    # Notify all subscribers
    @kitePost.kite.follwings.where(:Type => "member").each do |member|
      if member.follower.sendEmailNotifications
        @notification = Notification.new(
                :message => "One of the kites you follow has been updated.",
                :user => member.follower,
                :link => kite_url(@kitePost.kite))   
        
        NotificationMailer.notification_email(@notification).deliver
        
        @notification.save
      end
    end
    
          
    respond_to do |format|
      if @kitePost.save()
        format.html { redirect_to(@kitePost.kite, :notice => "Post was created successfully") }
        format.xml  { render :xml => @kitePost, :status => :created, :location => @kitePost }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kitePost.errors, :status => :unprocessable_entity }
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

    @kitePosts = KitePost.all.paginate(:page => params[:page], :per_page => 30)
    
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
end
