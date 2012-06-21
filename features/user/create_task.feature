@javascript
Feature: In order to track what needs to be done
  As a user
  I want to add tasks to my lists

  Scenario: Adding a task
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I fill in "My List"'s task title with "Learn to ride a shark"
    And I submit "My List"'s task form
    Then I should see the task "Learn to ride a shark"

  Scenario: Adding a task from "View all"
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I follow "History"
    And I fill in "My List"'s task title with "Learn to ride a shark"
    And I submit "My List"'s task form
    Then I should see the task "Learn to ride a shark"

  Scenario: Trying to add a blank task
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I fill in "My List"'s task title with ""
    And I submit "My List"'s task form
    Then "My List" should have no tasks

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

  Scenario: Adding a task with a due date
    Given today is "October 16, 2010"
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    | color  |
      | My List | email: user@example.com | 009000 |
    When I am on the dashboard page
    And I fill in "My List"'s task title with "@10/20 Learn to ride a shark"
    And I submit "My List"'s task form
    Then I should see the task "Learn to ride a shark" with a due date of "10/20"
    And I see the upcoming task "Learn to ride a shark" has a due date color of "009000"

  Scenario: Adding a task that escapes the due date
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I fill in "My List"'s task title with "!@10/20 Learn to ride a shark"
    And I submit "My List"'s task form
    Then I should see the task "@10/20 Learn to ride a shark"
    Then I should not see the task "!@10/20 Learn to ride a shark"
    When I am on the dashboard page
    Then I should see the task "@10/20 Learn to ride a shark"
    Then I should not see the task "!@10/20 Learn to ride a shark"

  Scenario: Adding a task with more than 255 characters
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I am on the dashboard page
    And I fill in "My List"'s task title with 400 "a"
    And I submit "My List"'s task form
    Then I should see the task with 400 "a"
    When I am on the dashboard page
    Then I should see the task with 400 "a"

  Scenario: New tasks appear before completed tasks
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following tasks exist:
      | list           | title     | completed |
      | title: My List | Completed | true      |
    When I am on the dashboard page
    And I fill in "My List"'s task title with "Doom"
    And I submit "My List"'s task form
    Then I should see the task "Doom" before "Completed"
