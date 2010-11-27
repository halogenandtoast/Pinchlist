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
      | title             | list           | due date   | completed |
      | Something         | title: My List | 2010-10-20 | true      |
      | Something else    | title: My List | 2010-10-21 | false     |
      | Finished          | title: My List | 2010-10-08 | true      |
      | One more thing    | title: My List | 2010-10-19 | false     |
      | And another thing | title: My List |            | false     |
      When I am on the dashboard page
      And I follow the archive link for "My List"
      Then I should see the following "My List" tasks in order:
        | Something else    |
        | One more thing    |
        | And another thing |
        | Something         |
        | Finished          |
