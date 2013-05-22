class Sharedpurpose < ActiveRecord::Base
  has_many :sharedpurposekites
  has_many :kites, :through => :sharedpurposekites
  has_one :founder, :class_name => 'User', :foreign_key => 'id'
  
  def UserCanView(user)
    
    if isPrivate == false
      return true
    end
    
    if user.id == founder_id
      return true
    end
    
    for kite in kites
      if kite.user.id == user
        return true
      end
    end
    
    return false
  end
  
  def self.search(criteria)
      search_condition = "%" + criteria + "%"
      find(:all, :conditions => ['name LIKE ?', search_condition])
    end
  
end
