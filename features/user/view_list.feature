Feature: Viewing list archive
  In order to see things I've already done
  As a user
  I want to view the list archive

  Scenario: Viewing tasks
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title   | user                    |
      | My List | email: user@example.com |
    And the following tasks exist:
      | title                 | list           | completed |
      | @10/20 Something      | title: My List | true      |
      | @10/21 Something else | title: My List | false     |
      | @10/08 Finished       | title: My List | true      |
      | @10/19 One more thing | title: My List | false     |
      | And another thing     | title: My List | false     |
      When I am on the dashboard page
      And I follow the archive link for "My List"
      And show me the page
      Then I should see the following "My List" tasks in order:
        | Something else    |
        | One more thing    |
        | And another thing |
        | Something         |
        | Finished          |
