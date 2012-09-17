require 'rubygems'
require 'mongo'
#source 'http://gemcutter.org'
source 'https://rubygems.org'



#gem 'mongo', '1.0'
gem 'nokogiri'
gem 'rails', '3.2.1'
gem "mongo_mapper"
gem "bcrypt-ruby", :require => "bcrypt"
gem "thin"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :test do
  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
end

group  :development, :test do
  gem "rspec-rails",      ">= 2.0.0"
  gem "autotest"
  gem "autotest-rails"
  #gem "ruby-debug"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
