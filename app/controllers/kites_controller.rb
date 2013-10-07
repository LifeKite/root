# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate kite objects and their
# associated assets (such as comments)
require 'nokogiri'
require 'open-uri'
require 'fastimage'
require 'will_paginate/array'

class KitesController < ApplicationController
  #before_filter :authenticate_user!, :except => [:index, :show, :randomSample]
  #before_filter :verify_is_admin_or_owner, :only => [:delete, :destroy]
  #before_filter :verify_is_owner, :only => [:edit, :update, :complete, :ShareKiteToSocialMedia, :personalIndex]
    
  # Minimum supported dimensions for web images that we make kites out of
  @@image_dimension_limit = 200
    
  # List all kites
  def index
    time_range = (1.week.ago..Time.now)
    
     @kites = Kite.where(:sharelevel => "public").paginate(:page => params[:page], :per_page => 12)
     
     
     @kiteCount = Kite.any? ? Kite.count : 0
          
     @newKites = Kite.NewKitesCount(time_range)
     @completedKites = Kite.CompletedKitesCount
     @recentComments = Comment.order("created_at DESC").take(3)
       
     #Currently not supported since we don't have following yet, just randomly choose three
     @popularKites = Kite.PopularKites
     @function = "Explore Kites"
     
              
    respond_to do |format|
      format.html { render :template => 'kites/index' }# index.html.erb
      format.xml  { render :xml => @kites }
    end
  end

  # Show my kites
  def personalIndex

    time_range = (1.week.ago..Time.now)
        
     @kites = current_user.kites.paginate(:page => params[:page], :per_page => 12)    
     
     @kiteCount = current_user.KiteCount
     @newKites = current_user.NewKiteCount(time_range)
     @completedKites = current_user.CompletedKitesCount
       
     @popularKites = current_user.RecentActivity
     @function = "My Kites"
     
    respond_to do |format|
      format.html { render :template => 'kites/index' } # index.html.erb
      format.xml  { render :xml => @kites }
    end
  end
  
  # Show kites I follow and support
  def mySupportIndex
    time_range = (1.week.ago..Time.now)
       
     @kiteIDs = current_user.follwing.collect{|a| a.kite_id}.flatten
     @kites = Kite.find(@kiteIDs).paginate(:page => params[:page], :per_page => 12)    
     
     @kiteCount = current_user.KiteCount
     @newKites = current_user.NewKiteCount(time_range)
     @completedKites = current_user.CompletedKitesCount
       
     @popularKites = current_user.RecentActivity
     @function = "Member Kites"
     
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
    
    #Queue up a proto-comment
    @comment = Comment.new
    @comments = @kite.comments(:order => "isHelpful DESC").paginate(:page => params[:page], :per_page => 3)
      
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

  # First step to allowing users to select images from a web source
  def newFromSource
    
    @kite = Kite.new
    @images = []
    @isAutoAdd = true

    if uri_is_valid?(params[:path])
      site = URI.parse(URI.encode(params[:path]))
      
      #grab the reference page passed in as parameter
      doc = Nokogiri::HTML(open(site))
      
      #find all of the images
      doc.css('img').each do |image|
        #debugger
        path = image.attribute('src').value
        
        if path[0..0] == '/'
          path = URI.join(site, path).to_s
        end  
        
        dimensions = FastImage.size(path, :timeout => 10.0)
                
        if(!dimensions.nil? && dimensions.length > 1 && dimensions[0] > @@image_dimension_limit && dimensions[1] > @@image_dimension_limit )
          img = {:path => path,
            :source => doc.title,
            :alttext => image.attribute('alt').value
          }
          
          @images << img
        end
      end
    end
    @site = site 
  
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
    else 
      @following = @kite.follwings.where(:user_id => current_user.id, :Type => params[:type]).first() 
    end 
    
    respond_to do |format| 
      if @following && @following.save()
        format.html { redirect_to(@kite, :notice => 'Kite has been followed.')}
        format.xml  { render :xml => @kites, :status => :created, :location => @kites }
        format.js {}
        format.json { render :json => @following, :status => :created}
      else  
        format.html { render :action => "owner_show" }
        format.xml  { render :status => :failure }
        format.js {}
        format.json { render :status => :unprocessable_entity }
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
        format.js {}
        format.json { render :json => @following, :status => :success }
      else  
        format.html { render :action => "owner_show" }
        format.xml  { render :status => :failure }
        format.js {}
        format.json { render :status => :unprocessable_entity }
      end
    end
    
  end
  
  # Commit a given kite to the data store
  def create
    
    if params[:kite].has_key? :ImageLocation 
      loc = JSON.parse params[:kite][:ImageLocation]
      params[:kite][:kiteimage] = open(loc['imagePage'], 'rb')
    end     
    
    @kite = Kite.new(params[:kite])
    @kite.CreateDate = Date.today
    @kite.user = current_user
    @kite.Completed = false
    # @kite.sharelevel = "public"

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
  
  def ShareKiteToSocialMedia
    
    @kite = Kite.find(params[:id])
    
    #Check that kite is public before continuing...
    if(@kite.sharelevel == "public")
      
      usr = FbGraph::User.me(@kite.user.name)
      usr.link!(
        :link => kite_url(@kite),
        :message => "I've shared a new goal on LifeKite"
      )
    end
  end
  
  private
    def verify_is_admin_or_owner

      if params[:id].nil?
              redirect_to(root_path)
      else
        @kite = Kite.find(params[:id])
        (current_user.nil? || @kite.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == 1 || current_user.id == @kite.user.id)
      end
    end
    
    def verify_is_owner

      if params[:id].nil?
        redirect_to(root_path)
      else
        @kite = Kite.find(params[:id])
        (current_user.nil? || @kite.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.id == @kite.user.id)
      end
    end 
  
    def uri_is_valid?(url)

      url = URI.encode(url)
      uri = URI.parse(url)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
end
