class FollwingsController < ApplicationController

  autocomplete :user, :username,
               :display_value => :KosherUsernameAndFullName,
               :extra_data => [:firstname, :lastname]

  # custom query for the above autocompletion, to search in multiple columns
  def get_autocomplete_items(parameters)
    User.select("id, username, firstname, lastname")
        .where(["LOWER(CONCAT_WS('|', firstname, lastname, username)) ILIKE ?", "%#{parameters[:term].downcase}%"])
  end

  def new
  end

  def index
  end

  def destroy
  end
  
end
