module ApplicationHelper

  #include Rails.application.routes.url_helpers
  #include Sprockets::Helpers::RailsHelper

  def asset_url asset
    "#{request.protocol}#{request.host_with_port}#{path_to_image(asset)}"
  end

  # This helper lets us do automatic hashtag substitution
  def format_tags(text, options={})
    content_tag(:p, formatless_tags(text), options)
  end

  def formatless_tags text
    # Replace hashtags with links to the coresponding hash index search
    text = raw(text ? text.gsub(HASHTAG_REGEX) { |m| link_to(m,hashIndex_kites_path(:tag=>m.strip[1..-1]))}: "")

    # Replace address tags with links to the coresponding user index search
    raw(text ? text.gsub(USERTAG_REGEX) { |m| link_to(m,userPublicKitesIndex_kites_path(:username=>m.strip[1..-1]))} : "")
  end

end
