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

  @javascript
  Scenario: Tasks are displayed in order
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I fill in "My List"'s task title with "Learn to ride a shark"
    And I submit "My List"'s task form
    And I fill in "My List"'s task title with "Wrestle a moose"
    And I submit "My List"'s task form
    Then I should see the task "Learn to ride a shark" followed by the task "Wrestle a moose"

  @javascript
  Scenario: Adding a task with a due date
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I fill in "My List"'s task title with "@10/20 Learn to ride a shark"
    And I submit "My List"'s task form
    Then I should see the task "Learn to ride a shark" with a due date of "10/20"

