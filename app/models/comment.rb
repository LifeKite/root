class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :kite
end
