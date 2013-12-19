class ApplicationController < ActionController::Base
  protect_from_forgery
  
   
  def after_sign_in_path_for(resource)
    
    sign_in_url = new_session_path(resource, :only_path => false)
    sign_up_url = new_registration_path(resource, :only_path => false) 
    paswd_rst_url = edit_password_path(resource, :only_path => false) 
    logger.info "Received login from " + request.referer
    if (request.referer == sign_in_url || request.referer == sign_up_url || request.referer.nil? )
      logger.info "Directing to kites path"  
      kites_path
    else
      logger.info "Directing to referer path"
      request.referer
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
