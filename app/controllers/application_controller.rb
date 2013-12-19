class ApplicationController < ActionController::Base
  protect_from_forgery
  
   
  def after_sign_in_path_for(resource)
    
    sign_in_url = new_session_path(resource, :only_path => false)
    sign_up_url = new_registration_path(resource, :only_path => false) 
    paswd_rst_url = edit_password_path(resource, :only_path => false) 
       
    if (request.referer == sign_in_url || request.referer == sign_up_url || request.referer.nil? )
        kites_path
    else
        request.referer
    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def after_reseting_password_path_for(resource)
    kites_path
  end
end
