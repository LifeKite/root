class User < ActiveRecord::Base
  has_many :kites
  has_many :assignments
  has_many :groups, :through => :assignments
  
    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  
  
  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive=>false
  has_friendly_id :username, :use_slug=>true, :strip_non_ascii=>true
end
