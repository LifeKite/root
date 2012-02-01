class Group < ActiveRecord::Base
  has_many :assignments
  has_many :users, :through => :assignments
  has_one :founder, :class_name => 'User', :foreign_key => 'id'
  has_many :invitations
end
