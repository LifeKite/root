module DeviseHelper
  def devise_error_messages!
    resource.errors.full_messages.map {|msg| content_tag(:div, msg, :class => "error") }.join.html_safe
  end
end