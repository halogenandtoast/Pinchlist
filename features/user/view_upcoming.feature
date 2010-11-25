Feature: View upcoming tasks
  In order to see what I should do next
  As a user
  I want to see upcoming tasks in order

  Scenario: Upcoming tasks do not exist
    Given I am signed in as "user@example.com/password"
    When I am on the dashboard page
    Then I do not see the upcoming tasks list

  @javascript
  Scenario: Creating an upcoming task
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title | user                    |
      | First | email: user@example.com |
    When I am on the dashboard page
    And I fill in "First"'s task title with "@10/20 Do stuff"
    And I submit "First"'s task form
    Then I should see the task "Do stuff"
    And I should see the upcoming task "Do stuff"

  @javascript
  Scenario: Destroying an upcoming task
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title  | user                    |
      | First  | email: user@example.com |
    And the following tasks exist:
      | title          | list          | due date   |
      | Something      | title: First  | 2010-10-20 |
    When I am on the dashboard page
    And I double click the upcoming task "Something"
    And I fill in the upcoming title for "Something" with "Something without a date"
    And I submit the upcoming title form for "Something"
    Then I should see the task "Something without a date"
    And I do not see the upcoming tasks list

  @javascript
  Scenario: Editing a task to be upcoming
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title  | user                    |
      | First  | email: user@example.com |
    And the following tasks exist:
      | title          | list          |
      | Something      | title: First  |
    When I am on the dashboard page
    And I double click "First"'s task "Something"
    And I fill in the title for "Something" with "@10/20 Something"
    And I submit the title form for "Something"
    Then I should see the task "Something"
    And I should see the upcoming task "Something" with a due date of "10/20"

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

  Scenario: Completed tasks exist
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title  | user                    |
      | First  | email: user@example.com |
      | Second | email: user@example.com |
    And the following tasks exist:
      | title          | list          | due date   | completed |
      | Something      | title: First  | 2010-10-20 | true      |
      | Something else | title: Second | 2010-10-21 | false     |
      | One more thing | title: First  | 2010-10-19 | false     |
      When I am on the dashboard page
      Then I should see the following upcoming tasks in order:
        | One more thing |
        | Something else |
        | Something      |

