# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class holds the core Kite object, including
# the kite image and initial description
class Kite < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :sharedpurposekites
  has_many :sharedpurposes, :through => :sharedpurposekites
  has_many :follwing
  has_many :followers, :through => :follwing, :class_name => 'User', :foreign_key => 'id'
  require 'aws/s3'
  
  @@aws_bucket_id = ENV['AMAZON_BUCKET_ID']
  @@access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
  @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  # Upload an image file to the kite
  def upload(uploaded_file)
    
    AWS::S3::Base.establish_connection!(
          :access_key_id => @@access_key_id,
          :secret_access_key => @@secret_access_key
        )
    name = uploaded_file.original_filename
    just_filename = Digest::SHA1.hexdigest(Time.now.to_s)
    
   
    AWS::S3::S3Object.store(just_filename, 
                            uploaded_file, 
                            @@aws_bucket_id, 
                            :access => :public_read)
    
    return AWS::S3::S3Object.url_for(just_filename, @@aws_bucket_id)[/[^?]+/]                            
  end
  
  # Mark the kite completed
  def complete
    update_attribute(:Completed, 1)
    update_attribute(:CompleteDate, Date.today)
    self.save!
  end
  
  # Make the kite public
  def promote
    update_attribute(:sharelevel, "public")
    self.save!
  end
  
  # Make the kite private
  def demote
    update_attribute(:sharelevel, "private")
    self.save!
  end
  
  # Remove any unassociated images which may have wandered into
  # the repository
  def cleanup
    AWS::S3::Base.establish_connection!(
              :access_key_id => @@access_key_id,
              :secret_access_key => @@secret_access_key
            )
    cleanName = File.basename(self.ImageLocation)
    
    if AWS::S3::S3Object.exists? cleanName, @@aws_bucket_id
      AWS::S3::S3Object.delete cleanName, @@aws_bucket_id
    end
  end
  
  # Function tests whether the current user instance (logged in)
  # can access a given kite.
  def UserCanView(testuser)
    if sharelevel == "public"
      return true
    end
    
    if user.id == testuser.id
      return true
    end
    
    # Test if this kite is shared
    # on a kitestring that this user is a 
    # member of
    for str in sharedpurposes
      if str.UserCanView(testuser)
        return true
      end
    end
        
    return false
  end
  
  
    
end
