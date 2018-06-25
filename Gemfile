source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'newrelic_rpm'
# gem 'rack-ssl', :require => 'rack/ssl'
gem 'thin'
gem 'stripe'
gem 'rails_autolink'
gem "active_model_serializers", "~> 0.8.0"

group :production do
  gem 'rails_12factor'
  gem 'dalli'
  gem 'memcachier'
end

group :assets do
  gem 'sass-rails', '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier'
end

gem 'pg'
gem 'devise'
gem 'haml'
gem 'sass'
gem 'chronic'
gem 'timelord', '0.0.6'
gem 'acts_as_list'
gem 'devise_invitable', github: 'scambra/devise_invitable'
gem 'hoptoad_notifier'
gem 'delayed_job'

group :development, :test do
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'database_cleaner'
  gem 'cucumber-rails', require: false
  gem 'bourne'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl', '~> 3.6.2'
  gem 'factory_girl_rails', '~> 3.6.0'
  gem 'shoulda', "3.0.0.beta2"
  gem 'email_spec'
  gem 'fakeweb'
end
