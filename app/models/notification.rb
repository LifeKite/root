class Notification < ActiveRecord::Base
  belongs_to :user
  
  def markViewed
    update_attribute(:state, "viewed")
    self.save!
  end
end
