class Sharedpurpose < ActiveRecord::Base
  has_many :sharedpurposekites
  has_many :kites, :through => :sharedpurposekites
  has_one :founder, :class_name => 'User', :foreign_key => 'id'
end
