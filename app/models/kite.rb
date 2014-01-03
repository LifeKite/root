# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class holds the core Kite object, including
# the kite image and initial description
class Kite < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :sharedpurposekites
  has_many :sharedpurposes, :through => :sharedpurposekites
  has_many :follwings
  has_many :followers, :through => :follwings, :class_name => 'User', :foreign_key => 'id'
  has_many :kitePosts
  
  validates_presence_of :Description  
  
  require 'net/http'
  require 'aws/s3'

  
  @@aws_bucket_id = ENV['AMAZON_BUCKET_ID']
  @@access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
  @@secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  attr_accessible :kiteimage, :Description, :ImageLocation, :sharelevel, :Details
  
  # validates_attachment_size :kiteimage, :less_than => 3.megabtyes
  has_attached_file :kiteimage, 
  :styles => { :medium => {:geometry => "600x800>", :format => :png}, :thumb => {:geometry => "215x215>", :format => :png} },
    :default_style => :original, 
    :storage => :s3,
    :s3_credentials => { :access_key_id => @@access_key_id, :secret_access_key => @@secret_access_key},
    :bucket => @@aws_bucket_id, 
    :default_url => "/images/missing_:style.png"
    
  validates_attachment_presence :kiteimage
    
  #Scopes
  
  #public kites
  scope :public_kites,lambda { where(:sharelevel => "public" )}
  
  #private kites
  scope :private_kites, lambda { where(:sharelevel => "private")}
    
  #my kites
  scope :my_kites, lambda { |user_id|
    (user_id ? where(:user_id => user_id) : {})
  }
  
  #kites shared with me
  scope :kites_shared_with_me, lambda { |user_id|
    (user_id ? Kite.joins(:follwings).where('follwings.Type' => "member").where('follwings.user_id' => user_id) : {})
  }
  
  #kites visible to me
  scope :kites_visible_to_me, lambda { |user_id|
    (user_id ? (Kite.public_kites + Kite.my_kites(user_id) + Kite.kites_shared_with_me(user_id)).uniq : {})
  }
  
  #new kites
  scope :new_kites, lambda { |time_range|
    (time_range ? where(:CreateDate => time_range) : {})
  }
  
  #completed kites
  scope :completed_kites, lambda { where(:Completed => true)}
  
  #search for kite by tag
  scope :search_by_tag, lambda { |tag|
      (tag ? where(["kites.tag LIKE ?", '%#'+ tag + '%'])  : {})
  } 
  
  #search by post tag
  scope :search_by_postTag, lambda { |tag|
    (tag ? where(["kite_posts.tag LIKE ?", '%#' + tag + '%']) : {})
  }
  
  def self.NewKitesCount(time_range)
    return new_kites(time_range).count
  end
  
  def self.CompletedKitesCount
    return completed_kites.count
  end
  
  def self.PopularKites
    Kite.joins(:follwings).where('follwings.Type' => "like")
      .select("kites.id, kites.\"Description\", kites.\"Completed\", kites.\"CreateDate\", kites.\"CompleteDate\", kites.user_id, kites.created_at, kites.updated_at, kites.sharelevel, kites.\"Details\", kites.kiteimage_file_name, kites.kiteimage_content_type, kites.kiteimage_file_size, kites.kiteimage_updated_at, count(follwings.id) as likes") 
      .group("kites.id, kites.\"Description\", kites.\"Completed\", kites.\"CreateDate\", kites.\"CompleteDate\", kites.user_id, kites.created_at, kites.updated_at, kites.sharelevel, kites.\"Details\", kites.kiteimage_file_name, kites.kiteimage_content_type, kites.kiteimage_file_size, kites.kiteimage_updated_at")
      .order("likes")
      .take(20)
      .sample(3)
  end
  
  def self.TagSearch(current_user, tag)
    @kites = (public_kites.search_by_tag(tag) + my_kites(current_user).private_kites.search_by_tag(tag) +
      kites_shared_with_me(current_user).search_by_tag(tag)).uniq
    @kitePostKites = Kite.joins(:kitePosts).search_by_postTag(tag) 
    
    return (@kites + @kitePostKites).uniq
  end
  
  #def self.ReformatStorage
  #  @kites = Kite.all
  #  @kites.each do |kite|
  #    kite.kiteimage = open(kite.ImageLocation, 'rb')
  #    kite.save!
  #  end
  #end  
  
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
  
  def FormattedCreateDate
    return self.CreateDate.strftime("%B %d, %Y")
  end
  
  def FormattedCompletedDate
    return self.CompleteDate.strftime("%B %d, %Y")
  end
  
  def LikeCount
    return follwings.where(:Type => "like").any? ? follwings.where(:Type => "like").count : 0 
  end  
  
  def FollowingCount
    return follwings.where(:Type => "member").any? ? follwings.where(:Type => "member").count : 0
  end
  
  def CommentCount
    return comments.count
  end
  
end
