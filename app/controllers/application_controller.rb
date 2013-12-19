class ApplicationController < ActionController::Base
  protect_from_forgery
  
   
  def after_sign_in_path_for(resource)
    
    sign_in_url = new_session_path(resource, :only_path => true)
    sign_up_url = new_registration_path(resource, :only_path => true) 
    paswd_rst_url = edit_password_path(resource, :only_path => true) 
    debugger
    if request.path.nil?
      logger.info "Null referrer"
    else
      logger.info "Received login from " + request.path
    end
    
    if (request.path == sign_in_url || request.path == sign_up_url || request.path.nil? || request.path == paswd_rst_url )
      logger.info "Directing to kites path"  
      kites_path
    else
      logger.info "Directing to referer path"
      request.path
    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def after_reseting_password_path_for(resource)
    logger.info "Completed password reset, redirecting to kites..."
    kites_path
  end
end
