Feature: Deleting a list

  Scenario: Deleting a list
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I click the delete link for "My List"
    Then I should see "List deleted."
    And I should not see the list "My List"

