@javascript
Feature: Sharing a list

  Scenario: Sharing a list with a current member
    Given the following user exists:
      | email                | password | password confirmation |
      | receiver@example.com | password | password              |
    And I am signed in as "user@example.com/password"
    And "user@example.com" has a "Shared" list
    When I am on the dashboard page
    Then I should see that the list is not shared
    And I click the share icon
    And I fill in share email with "receiver@example.com"
    And I submit the share form
    Then I should see that the list is shared with "receiver@example.com"
    And the share email field is blank
    When I am on the dashboard page
    Then I should see that the list is shared
    When I click the share icon
    Then I should see that the list is shared with "receiver@example.com"
    Then "receiver@example.com" should receive an email
    When "receiver@example.com" opens the email
    And they should receive an email with the following body:
    """
    shared the list "Shared" with you
    """
    And the list "Shared" should be shared with "receiver@example.com"
    When I sign out
    And I sign in as "receiver@example.com/password"
    Then I should see the list "Shared"

  Scenario: Sharing a list with a non-member
    Given I am signed in as "user@example.com/password"
    And "user@example.com" has a "Shared" list
    When I am on the dashboard page
    And I click the share icon
    And I fill in share email with "receiver@example.com"
    And I submit the share form
    Then I should see that the list is shared with "receiver@example.com"
    And the share email field is blank
    When I am on the dashboard page
    And I click the share icon
    Then I should see that the list is shared with "receiver@example.com"
    Then "receiver@example.com" should receive an email
    When "receiver@example.com" opens the email
    And they should receive an email with the following body:
    """
    user@example.com has shared the list "Shared" with you.
    """
    And "receiver@example.com" should see the invitation link in the email body
    And the list "Shared" should be shared with "receiver@example.com"

  Scenario: Sharing users should not see sharing details
    Given the following user exists:
      | email                | password | password confirmation |
      | receiver@example.com | password | password              |
    And I am signed in as "user@example.com/password"
    And "user@example.com" has a "Shared" list
    When I am on the dashboard page
    And I click the share icon
    And I fill in share email with "receiver@example.com"
    And I submit the share form
    And I sign out
    When I sign in as "receiver@example.com/password"
    Then I should see the list "Shared"
    And I should see that the list is shared
    And I should see that the list is shared with "user@example.com"
    But I should not see the form for sharing
    And I should not see a link to remove sharing

  Scenario: Sharing with an invalid email address
    Given the following user exists:
      | email                | password | password confirmation |
      | receiver@example.com | password | password              |
    And I am signed in as "user@example.com/password"
    And "user@example.com" has a "Shared" list
    When I am on the dashboard page
    And I click the share icon
    And I fill in share email with "receiver"
    And I submit the share form
    Then I should not see that the list is shared with "receiver"
    When I am on the dashboard page
    And I click the share icon
    Then I should not see that the list is shared with "receiver@example.com"
