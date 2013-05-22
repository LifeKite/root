class NotificationMailer < ActionMailer::Base
  default :from => 'lifekite-info@gmail.com'
  default :subject => 'Kite-comment notification'
  
  def notification_email(notification)
    @content_type = 'text/html'
    @user = User.find(notification[:user_id]);
    @subject = 'Kite-comment notification'
    @recipients = @user.email
    
    @message = notification[:message]
    @receiver = @user.username
    @kitepath = notification[:link]

    mail(:to => @user.email)
  end
end
