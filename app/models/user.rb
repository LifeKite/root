class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :kites
  has_many :assignments
  has_many :groups, :through => :assignments
  has_many :Invites
  has_many :Notifications
  
    
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
   
   def validate_reserved
      slug_text
      rescue FriendlyId::BlankError
      rescue FriendlyId::ReservedError
        @errors[friendly_id_config.method] = "is reserved.  Please choose something else."
        return false; 
   end
end
