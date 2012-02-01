class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location
  
  def store_location
      session[:user_return_to] = request.url unless params[:controller] == "devise/sessions"
  end
  
  def after_sign_in_path_for(resource)
      current_user
  end
end
