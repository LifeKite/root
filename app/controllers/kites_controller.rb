# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate kite objects and their
# associated assets (such as comments)
class KitesController < ApplicationController
  
  # List all kites
  def index
    time_range = (1.week.ago..Time.now)
    
     @kites = Kite.where(:sharelevel => "public")
     @kites.any? do |k|
       @kites = @kites.sample(10)
     end
     
     @kiteCount = Kite.any? ? Kite.count : 0
          
     @newKites = Kite.NewKitesCount(time_range)
     @completedKites = Kite.CompletedKitesCount
       
     #Currently not supported since we don't have following yet, just randomly choose three
     @popularKites = @kites.sample(3)
     @function = "Explore Kites"
          
    respond_to do |format|
      format.html { render :template => 'kites/index' }# index.html.erb
      format.xml  { render :xml => @kites }
    end
  end

  def personalIndex
    time_range = (1.week.ago..Time.now)
        
     @kites = current_user.kites    
     
     @kiteCount = current_user.KiteCount
     @newKites = current_user.NewKiteCount(time_range)
     @completedKites = current_user.CompletedKitesCount
       
     #Currently not supported since we don't have following yet, just randomly choose three
     @popularKites = @kites.sample(3)
     @function = "My Kites"
     
    respond_to do |format|
      format.html { render :template => 'kites/index' } # index.html.erb
      format.xml  { render :xml => @kites }
    end
  end
  
  # Retrieve a random sampling of all public kites, requires 
  # number of kites to retrieve, used for the initial page
  def randomSample
    time_range = (1.week.ago..Time.now)
    @kites = Kite.all.where(:sharelevel => "public").sample(params[:count])
    @kiteCount = @kites.count
    @newKites = @kites.all.where(:CreateDate => time_range).count
    @completedKites = @kites.count(:conditions => "Completed = true")
    
    #Currently not supported since we don't have following yet, just randomly choose three
    @popularKites = @kites.sample(3)
    respond_to do |format|
      format.html 
      format.xml { render :xml => @kites}
    end
  end
  
  # Open the view for a given kite
  def show
    @kite = Kite.find(params[:id])
    
     if @kite.UserCanView(current_user)
       if(current_user = @kite.user)
         render :action => 'owner_show'
       else
         render :action => 'shared_show'
       end
     else
       redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
     end
      
    
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @kite }
#    end
  end

  # Create a new kite object (will not persist untill passed
  # back to create)
  def new
   
    @kite = Kite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @kite }
    end
  end

  # Retrieve a kite for editing
  def edit
    @kite = Kite.find(params[:id])
      
    if @kite.UserCanView(current_user) == false
       redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
     end
  end

  # Add user to list of those following this kite
  def Follow
    
    @kite = Kite.find(params[:id])
   
    if(@kite.follwings.empty? || !@kite.follwings.exists?(:user_id => current_user.id, :Type => params[:type]))
      @following = Follwing.new
      @following.user_id = current_user.id
      @following.Type = params[:type]
      @following.kite = @kite 
    end
    
    respond_to do |format| 
      if @following && @following.save()
        format.html { redirect_to(@kite, :notice => 'Kite has been followed.')}
        format.xml  { render :xml => @kites, :status => :created, :location => @kites }
      else  
        format.html { render :action => "owner_show" }
        format.xml  { render :xml => @following.errors, :status => :created }
      end
    end
    
  end
  
  # Remove a kite following
  def Unfollow
    @kite = Kite.find(params[:id])
    if(@kite && @kite.follwings.any?)
      @following = @kite.follwings.where(:Type => params[:type]).first
    end
        
    respond_to do |format| 
      if @following && @following.destroy
        format.html { redirect_to(@kite, :notice => 'Kite has been unfollowed.')}
        format.xml  { render :xml => @kite, :status => :created, :location => @kite }
      else  
        format.html { render :action => "owner_show" }
        format.xml  { render :xml => @following.errors, :status => :created }
      end
    end
    
  end
  
  # Commit a given kite to the data store
  def create
    if(params[:kite].has_key?(:Upload))
      # upload = params[:kite][:Upload]
      params[:kite].delete(:Upload)
      
      @kite = Kite.new(params[:kite])
      @kite.ImageLocation = @kite.upload(upload)
    else
      @kite = Kite.new(params[:kite])
    end
    
    @kite.CreateDate = Date.today
    @kite.user = current_user
    @kite.Completed = false
    @kite.sharelevel = "public"

    respond_to do |format|
      if @kite.save()
        format.html { redirect_to(@kite, :notice => "Kite was created successfully") }
        format.xml  { render :xml => @kite, :status => :created, :location => @kite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update the parameters of a kite.  Kite and kite id are taken
  # as parameters
  def update
    @kite = Kite.find(params[:id])
      
    if @kite.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    else

      respond_to do |format|
        if @kite.update_attributes(params[:kite])
          format.html { redirect_to(@kite, :notice => 'Kite was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @kite.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def complete

    @kite = Kite.find(params[:id])
      
    if @kite.user.id == current_user.id
      @kite.complete
    end
    
    
    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
  
  def promote
    @kite = Kite.find(params[:id])
      
    if @kite.user.id == current_user.id
      @kite.promote
    end
    
    
    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
  
  def demote
    @kite = Kite.find(params[:id])
    
    if @kite.user.id == current_user.id
      @kite.demote
    end
      
    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /kites/1
  # DELETE /kites/1.xml
  def destroy
    @kite = Kite.find(params[:id])
      
    if @kite.user.id == current_user.id
      @kite.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(Kite) }
      format.xml  { head :ok }
    end
  end
   
end
