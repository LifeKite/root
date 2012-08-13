class InvitesController < ApplicationController
  # GET /Invites
  # GET /Invites.xml
  def index
    @Invites = Invite.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @Invites }
    end
  end

  # GET /Invites/1
  # GET /Invites/1.xml
  def show
    @Invite = Invite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @Invite }
    end
  end

  # GET /Invites/new
  # GET /Invites/new.xml
  def new
    @Invite = Invite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @Invite }
    end
  end

  # GET /Invites/1/edit
  def edit
    @Invite = Invite.find(params[:id])
  end

  # POST /Invites
  # POST /Invites.xml
  def create
    @Invite = Invite.new(params[:invite])
    # @Invite.group = params[:group]
    @Invite.initiated = Date.today
    error = false
    
    # If this is a new user, also create an account Invite for them
    if @Invite.email
      #check that this user doesn't already exist
      username = nil
      if(User.find_by_email(@Invite.email))
       error = true
      else
        username = rand(36**8).to_s(36)
        User.invite!(:email => @Invite.email, :username => username)
      end
      
      @Invite.user_id = User.find_by_username(username).id
    end
    
    respond_to do |format|
      if error == true
        format.html { redirect_to(@Invite.group, :notice => 'The specified email is already in use.  Please specify the user by their username to invite them to your group.') }
      elsif @Invite.save
        format.html { redirect_to(@Invite.group, :notice => 'Invite was successfully created.') }
        format.xml  { render :xml => @Invite, :status => :created, :location => @Invite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @Invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /Invites/1
  # PUT /Invites/1.xml
  def update
    @Invite = Invite.find(params[:id])

    respond_to do |format|
      if @Invite.update_attributes(params[:Invite])
        format.html { redirect_to(@Invite, :notice => 'Invite was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @Invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /Invites/1
  # PUT /Invites/1.xml
  def accept
    @Invite = Invite.find(params[:id])

    #add the user to the group specified in the Invite, then delete
    # the Invite
    respond_to do |format|
    if @Invite.accept()
      format.html { redirect_to(@Invite.group, :notice => 'Welcome to the group!')}
      format.xml { head :ok }
      @Invite.destroy
    else
      format.html { render :action => "accept" }
      format.xml  { render :xml => @Invite.errors, :status => 'Failed to join group' }
    end
    end
    
    
  end
  
  # DELETE /Invites/1
  # DELETE /Invites/1.xml
  def destroy
    @Invite = Invite.find(params[:id])
    @Invite.destroy

    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
end
