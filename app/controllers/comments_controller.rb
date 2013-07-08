# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to modify user comments
class CommentsController < ApplicationController
  
  # List all comments
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
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
    @comment.kite = Kite.find(params[:comment][:kite_id])
    @comment.user = current_user
    @kite = Kite.find(@comment.kite_id)
  
    if @kite.user.notifyOnKiteComment
      @notification = Notification.new(
        :message => "Someone has commented on your kite",
        :user => @kite.user,
        :link => kite_url(@kite))   
      
      if @kite.user.sendEmailNotifications
        NotificationMailer.notification_email(@notification).deliver
      end
      
      @notification.save
    end
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@kite, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new", :notice => params[:kite_id] }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
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
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
