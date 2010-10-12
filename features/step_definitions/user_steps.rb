Given /^I have signed up with "(.*)\/(.*)"$/ do |email, password|
  Factory :user, :email => email, :password => password, :password_confirmation => password
end

Given /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  steps %{
    Given I go to the new user session  page
    And I fill in "Email" with "#{email}"
    And I fill in "Password" with "#{password}"
    And I press "Sign in"
  }
end

Given /^I am signed in as "(.*)\/(.*)"$/ do |email, password|
  steps %{
    Given I have signed up with "#{email}/#{password}"
    And I sign in as "#{email}/#{password}"
  }
end