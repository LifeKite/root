class KitePost < ActiveRecord::Base
  attr_accessible :text, :image
  belongs_to :kite

  require 'aws/s3'

  has_attached_file :image, {
    :styles => { :medium => {:geometry => "300x300>", :format => :png}, :thumb => {:geometry => "215x215>", :format => :png} },
    :default_style => :original
  }

  scope :associated_kite, joins(:kite)

  scope :search_by_tag, lambda { |tag|
        (tag ? where(["kite_posts.tag LIKE ?", '%#'+ tag + '%'])  : {})
  }

  def FormattedCreateDate
    return self.created_at.strftime("%B %d, %Y")
  end
end
