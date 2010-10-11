Feature: In order to manage my information
  As a user
  I want to sign in

  Scenario: Signing in
    Given I have signed up with "user@example.com/password"
    And I am on the home page
    When I follow "Sign in"
    And I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should see "Sign Out"
