Feature: View upcoming tasks
  In order to see what I should do next
  As a user
  I want to see upcoming tasks in order

  Scenario: Upcoming tasks exist
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title  | user                    |
      | First  | email: user@example.com |
      | Second | email: user@example.com |
    And the following tasks exist:
      | title          | list          | due date   |
      | Something      | title: First  | 2010-10-20 |
      | Something else | title: Second | 2010-10-21 |
      | One more thing | title: First  | 2010-10-19 |
      When I am on the dashboard page
      Then I should see the following upcoming tasks in order:
        | One more thing |
        | Something      |
        | Something else |
