class FriendshipsController < ApplicationController
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

  def destroy
    @friend = current_user.friendships.find(params[:id])
    @friend.destroy
    flash[:notice] = "Removed friend."
    redirect_to current_user
  end

end
