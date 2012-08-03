class SharedpurposesController < ApplicationController

def new
  @sharedpurpose = Sharedpurpose.new
  respond_to do |format|
    format.html
    format.xml {render :xml => @sharedpurpose}
  end

end

def create
  @sharedpurpose = Sharedpurpose.new(params[:sharedpurpose])
  
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

def update
  @sharedpurpose = Sharedpurpose.find(params[:id])
  
  respond_to do |format|
    if @sharedpurpose.update_attributes(params[:id])
      format.html {redirect_to(@sharedpurpose, :notice => 'Shared purpose successfully update') }
      format.xml { head :ok }
    else
      format.html { render :action => "edit" }
      format.xml { render :xml => @sharedpurpose.errors, :status => :unprocessable_entity }
    end
  end
end

def show
  @sharedpurpose = Sharedpurpose.find(params[:id])
  
  respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sharedpurpose }
  end
end
end
