# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate the user, including 
# authentication and new user creation.  It also accesses assets
# owned by the user such as kites, comments, etc.
class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  # Show all users
  def index
    @users = User.all
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

end
