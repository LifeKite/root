class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @users = User.all
  end

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

    @ownedKitestrings = Sharedpurpose.where(:founder_id == @user.id)    
    @ki = (@ki + @ownedKitestrings)
    @ki.flatten!
    #debugger
    @ki.uniq!
            
    if(current_user = @user)
      render :action => 'owner_show'
    else
      render :action => 'shared_show'
    end
  end

end
