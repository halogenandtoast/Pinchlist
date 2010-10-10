Feature: In order to use the site
  As a visitor
  I want to be able to sign up

  Scenario: Sign up with valid credentials
    Given I am on the home page
    When I follow "Sign up"
    And I fill in "Email" with "visitor@example.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Sign up"
    Then I should see "You have signed up successfully"
    And I should be on the dashboard page
