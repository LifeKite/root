class KitePost < ActiveRecord::Base
  attr_accessible :text, :image
  belongs_to :kite
   
  require 'aws/s3'
  
  @@aws_bucket_id = ENV['AMAZON_BUCKET_ID']
  @@access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
  @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  has_attached_file :image,
    :styles => { :medium => {:geometry => "300x300>", :format => :png}, :thumb => {:geometry => "215x215>", :format => :png} },
        :default_style => :original, 
        :storage => :s3,
        :s3_credentials => { :access_key_id => @@access_key_id, :secret_access_key => @@secret_access_key},
        :bucket => @@aws_bucket_id
        
  def FormattedCreateDate
    return self.created_at.strftime("%B %d, %Y")
  end
end
