Feature: Viewing tasks
  In order to get the status of my tasks
  As a user
  I want to view them on my dashboard

  Scenario: Completed tasks exist
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following tasks exist:
      | title             | list           | due date   | completed |
      | Something         | title: My List | 2010-10-20 | true      |
      | Something else    | title: My List | 2010-10-21 | false     |
      | One more thing    | title: My List | 2010-10-19 | false     |
      | And another thing | title: My List |            | false     |
      When I am on the dashboard page
      Then I should see the following "My List" tasks in order:
        | Something else    |
        | One more thing    |
        | And another thing |
        | Something         |

