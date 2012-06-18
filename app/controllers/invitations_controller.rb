class InvitationsController < ApplicationController
  # GET /invitations
  # GET /invitations.xml
  def index
    @invitations = Invitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end

  # GET /invitations/1
  # GET /invitations/1.xml
  def show
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = Invitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/1/edit
  def edit
    @invitation = Invitation.find(params[:id])
  end

  # POST /invitations
  # POST /invitations.xml
  def create
    @invitation = Invitation.new(params[:invitation])

    @invitation.initiated = Date.today
    error = false
    
    # If this is a new user, also create an account invitation for them
    if @invitation.email
      #check that this user doesn't already exist

      if(User.find_by_email(@invitation.email))
       error = true
      else
        User.invite!(:email => @invitation.email, :username => rand(36**8).to_s(36))
      end
     
    end
    # @invitation.user = User.find(:first, :conditions => [ "username = ?", params[:user]])
    # @invitation.group = params[:group]
    
    
    respond_to do |format|
      if error == true
        format.html { redirect_to(@invitation.group, :notice => 'The specified email is already in use.  Please specify the user by their username to invite them to your group.') }
      elsif @invitation.save
        format.html { redirect_to(@invitation, :notice => 'Invitation was successfully created.') }
        format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.xml
  def update
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      if @invitation.update_attributes(params[:invitation])
        format.html { redirect_to(@invitation, :notice => 'Invitation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.xml
  def accept
    @invitation = Invitation.find(params[:id])
    
    #add the user to the group specified in the invitation, then delete
    # the invitation
    respond_to do |format|
    if @invitation.accept()
      format.html { redirect_to(@invitation.Group, :notice => 'Welcome to the group!')}
      format.xml { head :ok }
      @invitation.destroy
    else
      format.html { render :action => "accept" }
      format.xml  { render :xml => @invitation.errors, :status => 'Failed to join group' }
    end
    end
    
    
  end
  
  # DELETE /invitations/1
  # DELETE /invitations/1.xml
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
end
