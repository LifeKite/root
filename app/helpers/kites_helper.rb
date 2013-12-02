module KitesHelper
  def valid_json? json_  
    JSON.parse(json_)  
    return true  
  rescue JSON::ParserError  
    return false  
  end 
  
  # This helper lets us do automatic hashtag substitution 
  def format_tags text
    content_tag(:p, formatless_tags(text))
  end
  def formatless_tags text
    # Replace hashtags with links to the coresponding hash index search
    raw(text ? text.gsub(/#\S+/) { |m| link_to(m,hashIndex_kites_path(:tag=>m.strip[1..-1]))}: "")
    
    # Replace address tags with links to the coresponding user index search
    raw(text ? text.gsub(/@\S+/) { |m| link_to(m,userPublicKitesIndex_kites_path(:username=>m.strip[1..-1]))} : "")
  end
end
