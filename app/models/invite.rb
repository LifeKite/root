class Invite < ActiveRecord::Base
  belongs_to :group
  has_one :user
  
  def accept
    @group = Group.find(self.group_id)
    @user = User.find(self.user_id)
    @group.users << @user
  end
end
