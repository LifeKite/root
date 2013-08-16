# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class represents a comment on a kite
class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :kite
  validates_presence_of :user
  validates_presence_of :kite
  
  require 'aws/s3'
    
  @@aws_bucket_id = ENV['AMAZON_BUCKET_ID']
  @@access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
  @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  attr_accessible :commentimage, :content, :kite_id
  
  # validates_attachment_size :kiteimage, :less_than => 3.megabtyes
  has_attached_file :commentimage, 
  :styles => { :thumb => {:geometry => "215x215>", :format => :png} },
    :default_style => :thumb, 
    :storage => :s3,
    :s3_credentials => { :access_key_id => @@access_key_id, :secret_access_key => @@secret_access_key},
    :bucket => @@aws_bucket_id, 
    :default_url => "/images/missing_:style.png"
  
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
