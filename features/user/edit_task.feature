@javascript
Feature: Edit a task
  And I fill in "My List"'s task title with "@10/21 Learn to ride a shark"
  And I submit "My List"'s task form
  In order to change details about a task
  As a user
  I want to click and edit the title

  Scenario: Renaming a task in the upcoming list
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following task exists:
      | title               | list           |
      | @10/20 Ride a shark | title: My List |
    When I go to the dashboard page
    And I click the upcoming task "Ride a shark"
    And I fill in the upcoming title for "Ride a shark" with "@10/20 Lasso a shark"
    And I submit the upcoming title form for "Ride a shark"
    Then I should see the upcoming task "Lasso a shark"
    And I should see the task "Lasso a shark"
    When I go to the dashboard page
    Then I should see the upcoming task "Lasso a shark"
    And I should see the task "Lasso a shark"

  Scenario: Renaming a task in the upcoming list and changing it's due date
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    | color  |
      | My List | email: user@example.com | 009000 |
    And the following task exists:
      | title               | list           |
      | @10/20 Ride a shark | title: My List |
    When I go to the dashboard page
    And I click the upcoming task "Ride a shark"
    Then the upcoming title field for "Ride a shark" should contain "@10/20 Ride a shark"
    And I fill in the upcoming title for "Ride a shark" with "@10/30 Lasso a shark"
    And I submit the upcoming title form for "Ride a shark"
    Then I should see the upcoming task "Lasso a shark" with a due date of "10/30"
    And I see the upcoming task "Lasso a shark" has a due date color of "009000"
    And I should see the task "Lasso a shark" with a due date of "10/30"
    When I go to the dashboard page
    Then I should see the upcoming task "Lasso a shark" with a due date of "10/30"
    And I should see the task "Lasso a shark" with a due date of "10/30"

  Scenario: Renaming a task in it's list
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following task exists:
      | title               | list           |
      | @10/20 Ride a shark | title: My List |
    When I go to the dashboard page
    And I click the task "Ride a shark"
    And I fill in the title for "Ride a shark" with "@10/20 Lasso a shark"
    And I submit the title form for "Ride a shark"
    Then I should see the upcoming task "Lasso a shark"
    And I should see the task "Lasso a shark"
    When I go to the dashboard page
    Then I should see the upcoming task "Lasso a shark"
    And I should see the task "Lasso a shark"

  Scenario: Renaming a task via blur should cancel
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following task exists:
      | title        | list           |
      | @10/20 Ride a shark | title: My List |
    When I go to the dashboard page
    And I click the task "Ride a shark"
    And I fill in the title for "Ride a shark" with "@10/20 Lasso a shark"
    And I blur the title form for "Ride a shark"
    Then I should see the upcoming task "Ride a shark"
    And I should see the task "Ride a shark"

  Scenario: Reordering a task
    Given I am signed in as "user@example.com/password"
    And the following lists exist:
      | title         | user                    |
      | My List       | email: user@example.com |
    And the following tasks exist:
      | title               | list           | position |
      | Ride a shark        | title: My List | 1        |
      | Resurrect a mammoth | title: My List | 2        |
    When I go to the dashboard page
    And I drag the task "Ride a shark" over "Resurrect a mammoth"
    When I go to the dashboard page
    Then I should see the task "Resurrect a mammoth" before "Ride a shark"

  Scenario: Upcoming tasks should sort by date
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    | position |
      | My List | email: user@example.com | 1        |
    And the following tasks exist:
      | list           | title      |
      | title: My List | @10/20 Foo |
    When I go to the dashboard page
    And I fill in "My List"'s task title with "@10/19 Learn to ride a shark"
    And I submit "My List"'s task form
    And I fill in "My List"'s task title with "@10/21 Learn to ride a jellyfish"
    And I submit "My List"'s task form
    Then I should see the upcoming task "Learn to ride a shark" before "Foo"
    And I should see the upcoming task "Foo" before "Learn to ride a jellyfish"

  Scenario: Editing a task that escapes the due date
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following task exists:
      | list           | title     |
      | title: My List | !Foo 25th |
    When I am on the dashboard page
    And I click the task "!Foo 25th"
    Then the title being edited should be "!Foo 25th"
