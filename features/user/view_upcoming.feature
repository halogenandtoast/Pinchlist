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
      | title            | list         |
      | @10/20 Something | title: First |
    When I am on the dashboard page
    And I click the upcoming task "Something"
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
    And I click the task "Something"
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
      | title          | list          |
      | @10/20 Something      | title: First  |
      | @10/21 Something else | title: Second |
      | @10/19 One more thing | title: First  |
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
      | title          | list          | completed |
      | @10/20 Something      | title: First  | true      |
      | @10/21 Something else | title: Second | false     |
      | @10/19 One more thing | title: First  | false     |
      When I am on the dashboard page
      Then I should see the following upcoming tasks in order:
        | One more thing |
        | Something else |
        | Something      |

  Scenario: Upcoming tasks have colors
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following list exists:
      | title    | user                    | color  |
      | Colorful | email: user@example.com | FF00FF |
    And the following task exists:
      | title         | list            |
      | @10/20 A task | title: Colorful |
    When I am on the dashboard page
    Then I see the upcoming task "A task" has a due date color of "FF00FF"
