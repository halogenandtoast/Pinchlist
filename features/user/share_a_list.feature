Feature: Sharing a list

  @javascript
  Scenario: Sharing a list with a current member
    Given the following user exists:
      | email                | password | password confirmation |
      | receiver@example.com | password | password              |
    And I am signed in as "user@example.com/password"
    And the following list proxy exists:
      | list          | user                    |
      | title: Shared | email: user@example.com |
    When I am on the dashboard page
    And I click the share icon
    And I fill in share email with "receiver@example.com"
    And I submit the share form
    Then I should see that the list is shared with "receiver@example.com"
    When I am on the dashboard page
    And I click the share icon
    Then I should see that the list is shared with "receiver@example.com"
    Then "receiver@example.com" should receive an email
    When "receiver@example.com" opens the email
    And they should see "shared the list Shared with you" in the email body
    And the list "Shared" should be shared with "receiver@example.com"
