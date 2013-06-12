# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class allows for static content to be displayed in
# a way that at least superficially appears to be MVC 
# friendly
class HomeController < ApplicationController
  
  # Redirects to and renders the landing page (specified in routes)
  def index
    # render the landing page
  end

  # Renders the page with the specified id
  def show
    render :action => params[:id]
  end
end
