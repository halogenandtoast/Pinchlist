Given /^I have signed up with "(.*)\/(.*)"$/ do |email, password|
  create :user, :email => email, :password => password, :password_confirmation => password
end

Given /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  steps %{
    Given I go to the new user session page
    And I fill in email with "#{email}"
    And I fill in password with "#{password}"
    And I press "Sign in"
  }
end

When /^I sign out$/ do
  visit("/users/sign_out")
end

Given /^I am signed in as "(.*)\/(.*)"$/ do |email, password|
  steps %{
    Given I have signed up with "#{email}/#{password}"
    And I sign in as "#{email}/#{password}"
  }
end

Given /^I fill in email with "([^"]*)"$/ do |email|
  fill_in 'user_email', :with => email
end

Given /^I fill in password with "([^"]*)"$/ do |password|
  fill_in 'user_password', :with => password
end
