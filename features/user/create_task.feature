Feature: In order to track what needs to be done
  As a user
  I want to add tasks to my lists

  @javascript
  Scenario: Adding a task
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I fill in "My List"'s task title with "Learn to ride a shark"
    And I submit "My List"'s task form
    Then I should see "Learn to ride a shark"
