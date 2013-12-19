module KitesHelper
  def valid_json? json_  
    JSON.parse(json_)  
    return true  
  rescue JSON::ParserError  
    return false  
  end 
  
  
end
