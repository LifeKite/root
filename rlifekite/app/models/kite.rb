class Kite < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :sharedpurposekites
  has_many :sharedpurposes, :through => :sharedpurposekites
  require 'aws/s3'
    
  @@writeDirectory = "public/uploaded_images"
  @@referenceDirectory = "/uploaded_images/"
  
  @@access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
  @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  def upload(uploaded_file)
    
    AWS::S3::Base.establish_connection!(
          :access_key_id => @@access_key_id,
          :secret_access_key => @@secret_access_key
        )
    name = uploaded_file.original_filename
    just_filename = Digest::SHA1.hexdigest(Time.now.to_s)
    
    bucket = "LifeKite"
    
    AWS::S3::S3Object.store(just_filename, 
                            uploaded_file, 
                            bucket, 
                            :access => :public_read)
    
    return AWS::S3::S3Object.url_for(just_filename, bucket)[/[^?]+/]                            
  end
  
  def complete
    update_attribute(:Completed, 1)
    update_attribute(:CompleteDate, Date.today)
    self.save!
  end
  
  def promote
    update_attribute(:sharelevel, "public")
    self.save!
  end
  
  def demote
    update_attribute(:sharelevel, "private")
    self.save!
  end
  
  def cleanup
    AWS::S3::Base.establish_connection!(
              :access_key_id => @@access_key_id,
              :secret_access_key => @@secret_access_key
            )
    cleanName = File.basename(self.ImageLocation)
    
    if AWS::S3::S3Object.exists? cleanName, 'LifeKite'
      AWS::S3::S3Object.delete cleanName, 'LifeKite'
    end
  end
  
end
