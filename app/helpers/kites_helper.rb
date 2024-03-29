module KitesHelper
  def valid_json? json_
    JSON.parse(json_)
    return true
  rescue JSON::ParserError
    return false
  end

  def true_kites_path(parameters = {})

    # Pull in latent state information
    if !@text.nil?
      parameters[:text] = @text
    end

    if !@username.nil?
      parameters[:username] = @username
    end

    if params[:action] == "index"
      "/kites#{"?#{parameters.to_query}" if parameters.present? }"
    else
      "/kites/#{params[:action]}#{"?#{parameters.to_query}" if parameters.present? }"
    end
  end

  def kite_date_formated(date, info='Created')
    s = "<div class='created-text'>#{info}</div>"
    s += "<div class='created-month'>#{date.strftime('%B %d')}</div>"
    s += "<div class='created-year'>#{date.year}</div>"
    s
  end
end
