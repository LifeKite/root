class KitesController < ApplicationController
  # GET /kites
  # GET /kites.xml
  def index
    @kites = Kite.all
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @kites }
    end
  end

  # GET /kites/1
  # GET /kites/1.xml
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

  # GET /kites/new
  # GET /kites/new.xml
  def new
    
    
    @kite = Kite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @kite }
    end
  end

  # GET /kites/1/edit
  def edit
    @kite = Kite.find(params[:id])
      
    if @kite.UserCanView(current_user) == false
       redirect_to(current_user, :error => "The kite you have selected is private and cannot be viewed.")
     end
  end

  # POST /kites
  # POST /kites.xml
  def create
    if(params[:kite].has_key?(:Upload))
      upload = params[:kite][:Upload]
      params[:kite].delete(:Upload)
      
      @kite = Kite.new(params[:kite])
      @kite.ImageLocation = @kite.upload(upload)
    else
      @kite = Kite.new(params[:kite])
    end
    
    @kite.CreateDate = Date.today
    @kite.user = current_user
    @kite.Completed = false
    @kite.sharelevel = "private"

    respond_to do |format|
      if @kite.save()
        format.html { redirect_to(current_user, :notice => "Kite was created successfully") }
        format.xml  { render :xml => @kite, :status => :created, :location => @kite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /kites/1
  # PUT /kites/1.xml
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
      @kite.cleanup
      @kite.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
   
end
