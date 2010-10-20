Feature: Edit a task
  In order to change details about a task
  As a user
  I want to click and edit the title

  @javascript
  Scenario: Renaming a task in the upcoming list
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following task exists:
      | title        | list           | due date   |
      | Ride a shark | title: My List | 2010-10-20 |
    When I go to the dashboard page
    And I double click the upcoming task "Ride a shark"
    And I fill in the upcoming title for "Ride a shark" with "Lasso a shark"
    And I submit the upcoming title form for "Ride a shark"
    Then I should see the upcoming task "Lasso a shark"
    And I should see the task "Lasso a shark"
    When I go to the dashboard page
    Then I should see the upcoming task "Lasso a shark"
    And I should see the task "Lasso a shark"
