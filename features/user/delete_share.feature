@javascript
Feature: Sharing a list

  Scenario: Deleting a user from a shared list will remove the list from their dashboard
    Given the following user exists:
      | email                | password | password confirmation |
      | receiver@example.com | password | password              |
    And I am signed in as "user@example.com/password"
    And the following list exists for "user@example.com":
      | title  |
      | Shared |
    When I am on the dashboard page
    And I click the share icon
    And I fill in share email with "receiver@example.com"
    And I submit the share form
    And I sign out
    When I sign in as "receiver@example.com/password"
    Then I should see the list "Shared"
    When I sign out
    And I sign in as "user@example.com/password"
    And I click the share icon
    And I remove "receiver@example.com" from the list
    Then I should not see that the list is shared with "receiver@example.com"
    And I sign out
    And I sign in as "receiver@example.com/password"
    Then I should not see the list "Shared"
