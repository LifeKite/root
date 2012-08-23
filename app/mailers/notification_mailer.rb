class NotificationMailer < ActionMailer::Base
  def notifymail(notification)
    
    @user = User.find(notification[:user_id]);
    @subject = 'Kite-comment notification'
    @recipients = @user.email
    @from = 'lifekite-info@gmail.com'
    @message = notification[:message]
    @receiver = @user.username
    @kitepath = notification[:link]

    mail(
      :to => 'rwnagle3@gmail.com',
      :subject => 'Kite-comment notification')
  end
end
