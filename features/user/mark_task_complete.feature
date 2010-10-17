Feature: Marking a task complete
  In order to manage which tasks are complete
  As a user
  I want to click the task to mark it complete or incomplete

  @javascript
  Scenario: Marking an upcoming task as complete
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following task exists:
      | title        | list           | due date   |
      | Ride a shark | title: My List | 2010-10-20 |
    When I go to the dashboard page
    And I click on the upcoming task "Ride a shark"
    Then I should see the completed upcoming task "Ride a shark"
    And I should see the completed task "Ride a shark" in "My List"
    When I go to the dashboard page
    Then I should see the completed upcoming task "Ride a shark"
    And I should see the completed task "Ride a shark" in "My List"
