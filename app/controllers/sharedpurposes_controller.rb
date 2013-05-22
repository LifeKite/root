# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to manipulate a special type of
# group which is built around kites rather than users
class SharedpurposesController < ApplicationController

  # Create a new group
  def new
    @sharedpurpose = Sharedpurpose.new
    respond_to do |format|
      format.html
      format.xml {render :xml => @sharedpurpose}
    end
  
  end
  
  # Persist a new group
  def create
    @sharedpurpose = Sharedpurpose.new(params[:sharedpurpose])
    @sharedpurpose.isPrivate = true
    
    respond_to do |format| 
      if @sharedpurpose.save
        format.html { redirect_to(@sharedpurpose, :notice => 'Shared purpose was successfully created.')}
        format.xml  { render :xml => @sharedpurpose, :status => :created, :location => @sharedpurpose }
      else  
        format.html { render :action => "new" }
        format.xml  { render :xml => @sharedpurpose.errors, :status => :created }
      end
    end
  end
  
  # Update an existing group
  def update
    @sharedpurpose = Sharedpurpose.find(params[:id])
    
    respond_to do |format|
      if @sharedpurpose.update_attributes(params[:sharedpurpose])
        format.html {redirect_to(@sharedpurpose, :notice => 'Shared purpose successfully update') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @sharedpurpose.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # Generate a view of the selected group
  def show
    @sharedpurpose = Sharedpurpose.find(params[:id])

    respond_to do |format|
      if @sharedpurpose.UserCanView(current_user)
        format.html # show.html.erb
        format.xml  { render :xml => @sharedpurpose }
      else
        redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
      end
    end
  end
  
  # Generate an editable view of the current group
  def edit
    @sharedpurpose = Sharedpurpose.find(params[:id])
    
    if @sharedpurpose.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    end
  end
  
  # Add a kite to the group
  def selectKite
    @sharedpurpose = Sharedpurpose.find(params[:id])
      
    #Need to show the user all of their kites
    # which are not already members of this
    # string
    @unCleanKites = current_user.kites.includes(:sharedpurposes).where(:sharedpurposes => {:id => @sharedpurpose.id})
    @cleanKites = current_user.kites - @unCleanKites
      
    if @sharedpurpose.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    end
  end
  
  # Add a kite to the group
  def addKite

    @sharedpurpose = Sharedpurpose.find(params[:id])
    
    if @sharedpurpose.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    end  
    
    @kite = Kite.find(params[:kite_ids])
    @sharedpurpose.kites << @kite
    
    respond_to do |format| 
      if @sharedpurpose.save
        format.html { redirect_to(@sharedpurpose, :notice => 'New kite successfully added to the string.')}
        format.xml  { render :xml => @sharedpurpose, :status => :created, :location => @sharedpurpose }
      else  
        format.html { render :action => "addKite" }
        format.xml  { render :xml => @sharedpurpose.errors, :status => "Failed to add kite" }
      end
    end
  end
  
  # Remove kite from the group
  def removeKite
    @sharedpurpose = Sharedpurpose.find(params[:id])
    @kite = Kite.find(params[:kite_id])
      
    if @sharedpurpose.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    end
      
    
    respond_to do |format| 
      if @sharedpurpose.kites.delete(@kite)
        format.html { redirect_to(@sharedpurpose, :notice => 'Kite removed from the string.')}
        format.xml  { render :xml => @sharedpurpose, :status => :created, :location => @sharedpurpose }
      else  
        format.html { render :action => "removeKite" }
        format.xml  { render :xml => @sharedpurpose.errors, :status => "Failed to remove kite" }
      end
    end
  end
  
  # Make group public
  def promote
    @sharedpurpose = Sharedpurpose.find(params[:id])
    @sharedpurpose.isPrivate = false
    
    if @sharedpurpose.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    end
    
    respond_to do |format|
      if @sharedpurpose.save
        format.html { redirect_to(@sharedpurpose)}
        format.xml  { render :xml => @sharedpurpose, :status => :updated, :location => @sharedpurpose }
      else  
        format.html { render :action => "show" }
        format.xml  { render :xml => @sharedpurpose.errors, :status => "Failed to promote kitestring" }
      end
    end
  end
  
  # Make group private
  def demote
    @sharedpurpose = Sharedpurpose.find(params[:id])
    @sharedpurpose.isPrivate = true
    
    if @sharedpurpose.UserCanView(current_user) == false
      redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
    end
    
    respond_to do |format|
      if @sharedpurpose.save
        format.html { redirect_to(@sharedpurpose)}
        format.xml  { render :xml => @sharedpurpose, :status => :updated, :location => @sharedpurpose }
      else  
        format.html { render :action => "show" }
        format.xml  { render :xml => @sharedpurpose.errors, :status => "Failed to demote kitestring" }
      end
    end
  end
  
  # Find group by name
  def search
    @sharedpurposes = Sharedpurpose.search params[:search]
    
    render "index"
  end
  
end
