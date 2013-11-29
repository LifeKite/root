class Follwing < ActiveRecord::Base
  attr_accessible :kite_id, :user_id
  belongs_to :follower, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :kite
  
  validates :Type, :inclusion => %w(member like)
  validates  :user_id, :kite_id, :Type, :presence => true
end
