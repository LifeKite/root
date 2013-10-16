class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
     
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      
    else
      
      redirect_to new_user_registration_url
    end
  end
end