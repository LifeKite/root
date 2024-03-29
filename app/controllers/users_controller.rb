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
    debugger
    flash.keep
    redirect_to(edit_user_registration_path)
  end

  # Updated the user information based on id and user object
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      successfully_updated = if password_being_changed?(params[:user])
                               @user.update_with_password(params[:user])
                             else
                               # remove the virtual current_password attribute
                               # update_without_password doesn't know how to ignore it
                               params[:user].delete(:current_password)
                               @user.update_without_password(params[:user])
                             end

      if successfully_updated
        flash[:notice] = "Profile updated successfully"

        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true

        format.html {redirect_to(edit_user_registration_path)}
        format.xml {head :ok}
      else
        flash[:error] = @user.errors.full_messages.map {|msg| "<div>#{msg}</div>" }.join.html_safe

        format.html {redirect_to(edit_user_registration_path)}
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
    @user = current_user
    UserMailer.invite_email(current_user, params[:email]).deliver
    redirect_to(kites_path, :notify => "Your invitation has been sent")
  end 
  
  private
  def verify_is_admin
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == 1)
  end
  
  def verify_is_owner
    if params[:id].nil?
      logger.error("Owner only function called for with no user parameter") 
      redirect_to(root_path)
    end
    if current_user.nil?
      logger.error("Owner only function with no user logged in")
      redirect_to(root_path) 
    else 
      logger.info("Checking access for user #{params[:id]}")
      (redirect_to(root_path) unless current_user.id == params[:id].to_i)
    end
  end

  # per https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
  # check if we need password to update user data, i.e. if password was changed
  def password_being_changed?(user)
    user[:password].present? ||
        user[:password_confirmation].present?
  end

end
