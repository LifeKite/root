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
         :omniauthable, :invitable,
         :omniauth_providers => [:facebook],
         :authentication_keys => [:username]

         # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :notifyOnKiteComment, :notifyOnKitePromote, :sendEmailNotifications, :provider, :uid, :name
  has_many :kites, :dependent => :delete_all
  has_many :assignments, :dependent => :delete_all
  has_many :groups, :through => :assignments
  has_many :Invites
  has_many :Notifications, :dependent => :delete_all
  has_many :follwing, :dependent => :delete_all

  scope :search_by_fullname_or_username, lambda { |name|
    (name ? where(["lower(firstname) LIKE ? or lower(lastname) LIKE ? or lower(username) LIKE ? or lower(firstname) || ' ' || lower(lastname) LIKE ?", '%'+ name.downcase + '%', '%'+ name.downcase + '%', '%'+ name.downcase + '%','%'+ name.downcase + '%' ])  : {})
  }

  validates_presence_of :email,
                        :if => lambda { |a| a.errors[:email].blank? }
  validates_uniqueness_of :email, :case_sensitive => false,
                          :if => lambda { |a| a.errors[:email].blank? }

  validates_presence_of :username, :firstname, :lastname
  validates_uniqueness_of :username, :case_sensitive=>false,
                          :if => lambda { |a| a.errors[:username].blank? }

  has_friendly_id :username, :use_slug=>true, :strip_non_ascii=>true

  def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     login = conditions.delete(:username)
     where(conditions).where(["lower(username) = :value", { :value => login.strip.downcase }]).first
   end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if !signed_in_resource
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
    else
      #If we were passed in a signed in user, we need to associate that user to
      # the facebook auth that we've received
      logger.info "Received request to associate #{signed_in_resource.username} with facebook auth"
      user = User.where(:id => signed_in_resource.id).first
      if !user
        logger.info "User not found in database"
      else
        #Update the user with facebook-oauth-specific stuff, don't mess with their other
        # settings such as email and the like
        user.provider = auth.provider
        user.uid = auth.uid
        user.password = Devise.friendly_token[0,20]

      end
    end
    if user
      user.name = auth.credentials.token
      user.save!
    else
      user = User.create(:name => auth.credentials.token,
                           :username => auth.info.email,
                           :provider => auth.provider,
                           :uid => auth.uid,
                           :email => auth.info.email,
                           :firstname => auth.info.first_name,
                           :lastname => auth.info.last_name,
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

  # List the count of all kites
  def KiteCount
     return kites.any? ? kites.count : 0
  end

  # Show only uncompleted kites
  def ActiveKiteCount
    return kites.where(:Completed => true).any? ? kites.where(:Completed => true).count : 0
  end

  # Show kites newer than the time range
  def NewKites(time_range)
     return Kite.where(:CreateDate => time_range)
  end

  # Count those new kites
  def NewKiteCount(time_range)
     @newkites = NewKites(time_range)
     return @newkites.any? ? @newkites.count : 0
  end

  # Return the count of completed kites
  def CompletedKitesCount
     kites.any? ? kites.where(:Completed => true).count : 0
  end

  # Number of comments made by this user
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
    self.firstname.present? && self.lastname.present? ? "#{self.firstname} #{self.lastname}" : self.username
  end

  def KosherUsernameAndFullName
    self.firstname.present? && self.lastname.present? ? "#{self.username} (#{self.firstname} #{self.lastname})" : self.username
  end

  def KosherUsernameAndEmail
    "#{self.KosherUsername} (#{self.email})"
  end

  # Listing of most recent people commenting, following, or becomming members
  # of our kites
  def RecentActivity
    @followings = Follwing.where(:kite_id => kites.select("id"), :Type => "like").order("created_at DESC").take(5)
    @comments = Comment.where(:kite_id => kites.select("id")).order("created_at DESC").take(5)
    return (@followings + @comments).sort_by(&:created_at)
  end

  def is_following?(kite_id)
    follwing.find_by_kite_id(kite_id).present?
  end
end
