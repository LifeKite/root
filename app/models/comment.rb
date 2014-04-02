# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class represents a comment on a kite
class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :kite
  validates_presence_of :user
  validates_presence_of :kite

  require 'aws/s3'
  require 'rails_autolink'

  attr_accessible :commentimage, :content, :kite_id

  # validates_attachment_size :kiteimage, :less_than => 3.megabtyes
  has_attached_file :commentimage,
  :styles => { :thumb => {:geometry => "215x215>", :format => :png} },
    :default_style => :thumb,
    :default_url => "/images/missing_:style.png"

  scope :search_by_tag, lambda { |tag|
        (tag ? where(["tag LIKE ?", '%#'+ name + '%'])  : {})
  }

  #Mark the comment as helpful
  def markHelpful
    update_attribute(:isHelpful, true)
    self.save!
  end

  #Mark the comment as not helpful
  def unmarkHelpful
    update_attribute(:isHelpful, false)
  end

  def kite
    return Kite.find(kite_id)
  end

end
