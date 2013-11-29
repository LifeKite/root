# Author::    Rich Nagle  (mailto:rwnagle3+lifekite@gmail.com)
# Copyright:: Copyright (c) 2013 Lifekite, LLC

# This class represents the lifekite user, and contains
# references through devise to authenticate and manage a
# users authentication
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :name
  has_many :kites
  has_many :assignments
  has_many :groups, :through => :assignments
  has_many :Invites
  has_many :Notifications
  has_many :follwing
  
  scope :search_by_fullname_or_username, lambda { |name|
    (name ? where(["firstname LIKE ? or lastname LIKE ? or username LIKE ? or firstname || ' ' || lastname LIKE ?", '%'+ name + '%', '%'+ name + '%', '%'+ name + '%','%'+ name + '%' ])  : {})
  }
    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
  :authentication_keys => [:username]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :notifyOnKiteComment, :notifyOnKitePromote, :sendEmailNotifications 
  
  
  validates_presence_of :email
  validates_uniqueness_of :username, :case_sensitive=>false
  validates_uniqueness_of :email, :case_sensitive=>true
  has_friendly_id :username, :use_slug=>true, :strip_non_ascii=>true
  
  def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     login = conditions.delete(:username)
     where(conditions).where(["lower(username) = :value", { :value => login.strip.downcase }]).first
   end
   
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      user.name = auth.credentials.token
      user.save!
    else
      user = User.create(:name => auth.credentials.token,
                           :username => auth.extra.raw_info.name,
                           :provider => auth.provider,
                           :uid => auth.uid,
                           :email => auth.info.email,
                           :password => Devise.friendly_token[0,20]
                        )
    end
    user
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end 
  
  def validate_reserved
      slug_text
      rescue FriendlyId::BlankError
      rescue FriendlyId::ReservedError
        @errors[friendly_id_config.method] = "is reserved.  Please choose something else."
        return false; 
  end
   
  def KiteCount
     return kites.any? ? kites.count : 0
  end
   
  def NewKites(time_range)
     return Kite.where(:CreateDate => time_range)
  end
   
  def NewKiteCount(time_range)
     @newkites = NewKites(time_range)
     return @newkites.any? ? @newkites.count : 0
  end  
   
  def CompletedKitesCount
     kites.any? ? kites.where(:Completed => true).count : 0
  end
   
  def CommentCount
     return Comment.where(:user_id => id).count
  end
   
  def FormattedCreateDate
    return self.created_at.strftime("%B %d, %Y")
  end  
  
  def FormattedLastLoginDate
    return self.last_sign_in_at.strftime("%B %d, %Y")
  end
  
  def KosherUsername
    if !self.firstname.nil? && !self.lastname.nil?
      return "#{self.firstname} #{self.lastname}"
    else
      return self.username
    end
  end   
  
  def KosherUsernameAndEmail
    return "#{self.KosherUsername} (#{self.username})"
  end
  
  # Listing of most recent people commenting, following, or becomming members
  # of our kites 
  def RecentActivity
    @followings = Follwing.where(:kite_id => kites.select("id"), :Type => "like").order("created_at DESC").take(5)
    @comments = Comment.where(:kite_id => kites.select("id")).order("created_at DESC").take(5)
    return (@followings + @comments).sort_by(&:created_at)
  end
end
