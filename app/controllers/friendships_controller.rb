# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class exposes methods to allow users to mark each other as
# friends
class FriendshipsController < ApplicationController
  
  # Create a new friendship :)
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
      if @friendship.save
        flash[:notice] = "Added friend."
        redirect_to root_url
      else
        flash[:error] = "Unable to add friend."
        redirect_to root_url
      end
  end

  # Destroy a current friendship :(
  def destroy
    @friend = current_user.friendships.find(params[:id])
    @friend.destroy
    flash[:notice] = "Removed friend."
    redirect_to current_user
  end

end
