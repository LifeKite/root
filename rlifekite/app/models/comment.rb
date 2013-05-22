class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :kite
  
  def markHelpful
    update_attribute(:isHelpful, true)
    self.save!
  end
  
  def unmarkHelpful
    update_attribute(:isHelpful, false)
  end
  
end
