class User < ActiveRecord::Base
  has_many :kites
  has_many :assignments
  has_many :groups, :through => :assignments
  has_many :invitations
  
    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
  :authentication_keys => [:username]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  
  
  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive=>false
  has_friendly_id :username, :use_slug=>true, :strip_non_ascii=>true
  
  def self.find_for_database_authentication(warden_conditions)
     conditions = warden_conditions.dup
     login = conditions.delete(:username)
     where(conditions).where(["lower(username) = :value", { :value => login.strip.downcase }]).first
   end
end
