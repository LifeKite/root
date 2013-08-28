module ApplicationHelper
  
  #include Rails.application.routes.url_helpers
  #include Sprockets::Helpers::RailsHelper
  
  def asset_url asset
    "#{request.protocol}#{request.host_with_port}#{path_to_image(asset)}"
  end
  
end
