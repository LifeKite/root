module UsersHelper
  def safe_user_edit_form_for(resource, *args, &block)
    options = args.extract_options!
    
    if resource.provider == "facebook"
      args.delete("url")
      args.delete("as") 
    end
    form_for(resource, *args, &block)
  end
end
