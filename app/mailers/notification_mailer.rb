class NotificationMailer < ActionMailer::Base
  def mail(notification)
    @subject = 'Kite-comment notification'
    @recipients = notification.user.email
    @from = 'lifekite-info@gmail.com'
    @message = notification.message
    @receiver = notification.user.username
    @kitepath = notification.link
  end
end
