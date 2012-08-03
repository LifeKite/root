class HomeController < ApplicationController
  def index
    # render the landing page
  end

  def show
    render :action => params[:id]
  end
end
