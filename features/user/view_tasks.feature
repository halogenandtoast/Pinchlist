Feature: Viewing tasks
  In order to get the status of my tasks
  As a user
  I want to view them on my dashboard

  Scenario: Expired tasks should not display
    Given today is "October 8, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following tasks exist:
      | title    | list           | completed |
      | Finished | title: My List | true      |
    When today is "October 16, 2010"
    And I am on the dashboard page
    Then I should not see the task "Finished"
