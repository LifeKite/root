class UserMailer < ActionMailer::Base
  default :from => "info@lifekite.com"

  def password_reset(user, password)
    @user = user
    @password = password
    mail(:to => user.email,
         :subject => 'Password Reset Notification')
  end
  
  def invite_email(user, emailAddr)
    @user = user
    @url  =  root_path
    mail(:to => emailAddr,
             :subject => 'LifeKite Invitation')
    end
end