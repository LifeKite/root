module KitesHelper
  def valid_json? json_  
    JSON.parse(json_)  
    return true  
  rescue JSON::ParserError  
    return false  
  end 
  
  def true_kites_path(parameters = {})
    "/kites/#{params[:action]}#{"?#{parameters.to_query}" if parameters.present? }"
  end
end
