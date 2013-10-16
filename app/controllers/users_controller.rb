# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate the user, including 
# authentication and new user creation.  It also accesses assets
# owned by the user such as kites, comments, etc.
class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_is_admin, :only => [:index, :ForcePasswordReset, :destroy]
  before_filter :verify_is_owner, :only => [:edit, :update]
    
  # Show all users
  def index
   
    @users = User.all
    @kites = current_user.kites
  end

  # Retrieve an editable user based on id
  def edit
    if (params.has_key?(:id))
          @user =  User.find(params[:id])   
            
    else
      @user = current_user
    end
  end
  
  # Updated the user information based on id and user object
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {redirect_to(@user)}
        format.xml {head :ok}
      else
        format.html {render :action => "edit" }
        format.xml {render :xml => @user.errors}
      end
    end
  end
  
  # Generate user view 
  def show
    if (params.has_key?(:id))
      @user =  User.find(params[:id])   
        
    else
      @user = current_user
    end
    
    @ki = current_user.kites 
    @ki.map! do |kit|
      if(kit.sharedpurposes.nil? != true) 
          kit.sharedpurposes.all
      end
    end

    @ownedKitestrings = Sharedpurpose.where(:founder_id => @user.id)    
    @ki = (@ki + @ownedKitestrings)
    @ki.flatten!
    #debugger
    @ki.uniq!
    
    if(@user.id == current_user.id)
      @summarykites = @user.kites.paginate(:page => params[:page], :per_page => 5)
    else
      @summarykites = @user.kites.where(:sharelevel => "public").paginate(:page => params[:page])
     end
            
    if(current_user = @user)
      render :action => 'owner_show'
    else
      render :action => 'shared_show'
    end
  end

  def destroy
     @user = User.find(params[:id])
     @user.destroy
          
     respond_to do |format|
       format.html { redirect_to(request.referer) }
       format.xml  { head :ok }
     end
  end
  
  def ForcePasswordReset
          
    @user =  User.find(params[:id]) 
    random_password = User.send(:generate_token, 'encrypted_password').slice(0,8)
    @user.password = random_password
    UserMailer.password_reset(@user, random_password).deliver
    
    redirect_to(request.referer, :notify => "Password reset email has been sent")
  end
  
  def GetKites
    
    @user =  User.find(params[:id])
    @kites = @user.kites
    
    respond_to do |format|
      format.html {render :action => "show" }
      format.js {}
      format.json { render :json => {:kites => @kites, :status => :ok}}
      format.xml  { head :ok }
    end
  end
  
  # Load the page for that invitation system
  def showInvite
    @user = current_user
  end
  
  # A very simple invitation system
  def invite
    
    UserMailer.invite_email(@user, params[:email]).deliver
    redirect_to(kites_path, :notify => "Your invitation has been sent")
  end
  
  private
  def verify_is_admin
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == 1)
  end
  
  def verify_is_owner
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == id)
  end
  
  
  
end
