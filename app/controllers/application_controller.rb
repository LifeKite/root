class ApplicationController < ActionController::Base
  protect_from_forgery
  
   
  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')  
 
    if (request.referer == sign_in_url)
        kites_path
      else
        request.referer
      end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
