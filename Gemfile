source :rubygems

gem 'rails', '3.0.3'
gem 'pg'
gem 'devise'
gem 'haml'
gem 'chronic'
gem 'timelord', '0.0.4'
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
  gem 'akephalos', :git => "git://github.com/thoughtbot/akephalos.git"
  gem 'capybara', '~> 0.3.8'
  gem 'timecop'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'bourne'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
  gem 'shoulda', :git => 'git://github.com/thoughtbot/shoulda.git'
end
