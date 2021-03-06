source :rubygems
ruby '1.9.3'

gem 'attr_encrypted'
gem 'bcrypt-ruby'
gem 'bootstrap_forms'
gem 'bson_ext'
gem 'charlock_holmes', :require => false
gem 'chronic'
gem 'eco'
gem 'foreman'
gem 'haml'
gem 'jquery-rails'
gem 'js-routes'
gem 'kaminari'
gem 'magiconf'
gem 'mail', :require => false
gem 'mongoid'
gem 'mongoid-ancestry'
gem 'nokogiri', :require => false
gem 'nested_form', :git => 'git://github.com/ryanb/nested_form.git'
gem 'puma'
gem 'pusher'
gem 'rails', '3.2.9'
gem 'sidekiq'
gem 'tire'
gem 'vcard', :require => false
gem 'warden'
gem 'yajl-ruby', :require => 'yajl/json_gem'

# cancan needs to be last so it picks up the mongo driver
gem 'cancan'

# Sidekiq engine
group :sidekiq do
  gem 'sinatra', :require => false
  gem 'slim'
end

group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'sass-rails', '~> 3.2.5'
  gem 'uglifier', '>= 1.3.0'
end

group :development do
  gem 'awesome_print'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'heroku'
  gem 'hirb'
  gem 'rb-fsevent'
  gem 'quiet_assets'
  gem 'terminal-notifier-guard'
  gem 'wirble'
  gem 'yard'
end

group :test, :developement do
  gem 'redcarpet'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'mongoid-rspec'
  gem 'rspec-rails'
  gem 'simplecov', :require => false
  gem 'spork'
  gem 'webmock', :require => false
end

group :production do
  gem 'daemons'
end
