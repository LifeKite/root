class FollwingsController < ApplicationController
  
  # Tried this first using scopes, but autocomplete gem doesn't give you the capability to pass
  # parameters into scopes.  Eventually it turned out the best way to get this working durably was to
  # override the item retreival with our own filter.
  def users_get_autocomplete_items(parameters)
    super(parameters).where(["firstname LIKE ? OR lastname LIKE ? OR username LIKE ? OR email LIKE ?",
                             "%#{parameters[:term]}%",
                             "%#{parameters[:term]}%",
                             "%#{parameters[:term]}%",
                             "%#{parameters[:term]}%"
                            ])
  end

  autocomplete :user, :username,
               :display_value => :KosherUsernameAndFullName,
               :extra_data => [:firstname, :lastname, :email]

  def new
  end

  def index
  end

  def destroy
  end
  
end
