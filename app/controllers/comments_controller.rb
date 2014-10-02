# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to modify user comments
class CommentsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :verify_is_owner, :only => [:delete, :destroy]

  # List all comments
  def index
    @comments = Comment.all.paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
      format.js {}
      format.json { render :json => {:comments => @comments, status => :ok}}
    end
  end

  # Generate a comment view
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # Create a new comment
  def new
    @comment = Comment.new
    @kite = Kite.find(params[:kite])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # Edit an existing comment
  def edit
    @comment = Comment.find(params[:kite_id])
    @kite = Kite.find(@comment.kite_id)
  end

  # Persist a new comment in the data store
  def create
    @comment = Comment.new(params[:comment])
    @comment.content = params[:comment][:content]
    @comment.kite = Kite.find(params[:comment][:kite_id])
    @comment.user = current_user
    @comment.tag = @comment.content.scan(HASHTAG_REGEX).join(",")
    @kite = Kite.find(@comment.kite_id)

    if @comment.save
      send_comment_update_notification("Someone has commented on your kite", @comment, @kite.user)

      # Also, anyone who was specifically mentioned should be notified
      @target_users = @comment.content.scan(USERTAG_REGEX)
      @target_users.each do |tu|
        user = User.where(:username => tu.strip[1..-1]).first
        send_comment_update_notification("Someone has mentioned you in their kite status.", @comment, user)
      end

      # Also, let those following the kite know
      @comment.kite.followers.each do |member|
        send_comment_update_notification("A comment has been made on one of the kites you follow.",
        @comment, member)
      end

      respond_to do |format|
        format.html { redirect_to(@kite, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.js {}
        format.json { render :json => @comment, :status => :created}
      end
    else
      respond_to do |format|
        format.html { render :action => "new", :notice => params[:kite_id] }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        format.js {}
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update an existing comment in the data store
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Promote a comment as helpful
  def markHelpful
    @comment = Comment.find(params[:id])
    @kite = Kite.find(@comment.kite_id)
    
    if @comment.user.notifyOnKitePromote
      @notification = Notification.new(
          :message => @kite.user.username + " found your comment helpful.",
          :user => @comment.user,
          :link => kite_url(@kite))   
        
      if @comment.user.sendEmailNotifications
        NotificationMailer.notification_email(@notification).deliver
      end
      
      @notification.save
      
    end
    
    
    respond_to do |format|
          if @comment.markHelpful() 
            format.html { redirect_to(@kite) }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
          end
        end
  end
  
  # Demote a comment as not helpful
  def unmarkHelpful
    @comment = Comment.find(params[:id])
    @kite = Kite.find(@comment.kite_id)     
        
        respond_to do |format|
          if @comment.unmarkHelpful()
            format.html { redirect_to(@kite) }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
          end
        end
  end
  
  # Delete a comment
  def destroy
    @comment = Comment.find(params[:id])
    @kite = Kite.find(@comment.kite_id)   
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(@kite, :notice => 'Comment was removed.') }
      format.xml  { render :status => :deleted }
      format.js {}
      format.json { render :json => @comment, :status => :deleted}
    end
  end
  
  private
  def send_comment_update_notification(message, comment, user)
    
    if comment.user != user
      @notification = Notification.new(
        :message => "#{message}: #{comment.content}".truncate(255),
        :user => user,
        :link => kite_url(comment.kite, :showComments=>true),
        :flavor => "comment") 
      if user && comment.kite.user.sendEmailNotifications
        NotificationMailer.notification_email(@notification).deliver
      end    
      @notification.save
    end
  end
  
def verify_is_owner

    if params[:id].nil?
      redirect_to(root_path)
    else
      @comment = Comment.find(params[:id])
      (current_user.nil? || @comment.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == @comment.user.id || current_user.id == @comment.kite.user.id)
    end
  end 
  
end
