Feature: In order to protect my information
  As a user
  I want to sign out

  Scenario: Signing out
    Given I am signed in as "user@example.com/password"
    And I am on the dashboard page
    When I follow "Sign Out"
    Then I should see "Signed out successfully."
