# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class represents a comment on a kite
class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :kite
  validates_presence_of :user
  validates_presence_of :kite
  
  #Mark the comment as helpful
  def markHelpful
    update_attribute(:isHelpful, true)
    self.save!
  end
  
  #Mark the comment as not helpful
  def unmarkHelpful
    update_attribute(:isHelpful, false)
  end
  
end
