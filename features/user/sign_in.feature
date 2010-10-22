Feature: In order to manage my information
  As a user
  I want to sign in

  Scenario: Signing in
    Given I have signed up with "user@example.com/password"
    And I am on the home page
    And I fill in email with "user@example.com"
    And I fill in password with "password"
    And I press "Login"
    Then I should be on the dashboard page
    And I should see "Sign Out"
