class AddInvitationTokenToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :invitation_token, :string

  end
end
