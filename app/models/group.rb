class Group < ActiveRecord::Base
  has_many :assignments
  has_many :users, :through => :assignments
  has_one :founder, :class_name => 'User', :foreign_key => 'id'
  has_many :Invites
  
  def self.search(criteria)
    search_condition = "%" + criteria + "%"
    find(:all, :conditions => ['name LIKE ?', search_condition])
  end
end
