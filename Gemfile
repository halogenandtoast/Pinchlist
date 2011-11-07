source :rubygems

gem 'rails', '3.1.1'
gem 'jquery-rails'
gem 'newrelic_rpm'
gem 'rack-ssl', :require => 'rack/ssl'
gem 'thin'
group :assets do
  gem 'sass-rails', '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.0'
  gem 'uglifier'
end
gem 'pg'
gem 'devise'
gem 'haml'
gem 'sass'
gem 'chronic'
gem 'timelord', :git => "git://github.com/halogenandtoast/timelord.git"
gem 'acts_as_list'
gem 'devise_invitable'
gem 'hoptoad_notifier'

group :development do
  gem 'hpricot'
  gem 'ruby_parser'
end

group :development, :test do
  gem 'rspec-rails'
  platforms :ruby_19 do
    gem 'ruby-debug19', :require => 'ruby-debug'
  end
  platforms :ruby_18 do
    gem 'ruby-debug'
  end
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'timecop'
  gem 'database_cleaner'
  gem 'cucumber-rails', '1.1.1'
  gem 'bourne'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
  gem 'shoulda', "3.0.0.beta2"
  gem 'email_spec'
end
