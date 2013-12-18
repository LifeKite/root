module DeviseHelper
  def devise_error_messages!
    resource.errors.full_messages.map {|msg| content_tag(:span, msg) }.join
  end
end