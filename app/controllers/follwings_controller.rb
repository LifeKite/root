class FollwingsController < ApplicationController
  
  # Tried this first using scopes, but autocomplete gem doesn't give you the capability to pass
  # parameters into scopes.  Eventually it turned out the best way to get this working durably was to
  # override the item retreival with our own filter.
  def get_autocomplete_items(parameters)
    User.where(["firstname LIKE ? or lastname LIKE ? or username LIKE ? or firstname || ' ' || lastname LIKE ?", '%'+ parameters[:term] + '%', '%'+ parameters[:term] + '%', '%'+ parameters[:term] + '%','%'+ parameters[:term] + '%' ]).select('id, firstname, lastname, email')
  end

  
  autocomplete :user, :name, :display_value => :KosherUsername
  def new
  end

  def index
  end

  def destroy
  end
  
end
