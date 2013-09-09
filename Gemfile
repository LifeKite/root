source 'http://rubygems.org'
ruby "1.9.3"
gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'railties'
gem 'devise', '>= 2.0.0'
gem 'friendly_id', '3.2.1'
gem 'jquery-rails'
gem 'paperclip', "~> 3.0"
gem 'aws-sdk'
gem 'aws-s3'
gem 'devise_invitable', '~> 1.0.0'
gem 'will_paginate', '~> 3.0.0'
gem 'fastimage'
gem 'omniauth'
gem 'omniauth-facebook'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
group :development do
	gem 'debugger'
	gem 'sqlite3', :require => 'sqlite3'
end
# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'


# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
group :production do
	# gem 'heroku'
	gem 'pg'
	gem 'thin'
end
