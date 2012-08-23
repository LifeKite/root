class NotificationMailer < ActionMailer::Base
  default :from => 'lifekite-info@gmail.com'
  def notifymail(notification)
    
    @user = User.find(notification[:user_id]);
    @subject = 'Kite-comment notification'
    @recipients = @user.email
    
    @message = notification[:message]
    @receiver = @user.username
    @kitepath = notification[:link]

    mail(
      :to => 'rwnagle3@gmail.com',
      :subject => 'Kite-comment notification')
  end
end
