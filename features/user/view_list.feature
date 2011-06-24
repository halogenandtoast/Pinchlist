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
      | title                 | list           |
      | @10/20 Something      | title: My List |
      | @10/21 Something else | title: My List |
      | @10/08 Finished       | title: My List |
      | @10/19 One more thing | title: My List |
      | And another thing     | title: My List |
    And I complete "Something" on "2010-10-20"
    And I complete "Finished" on "2010-10-08"
    When I am on the dashboard page
    And I follow the archive link for "My List"
    Then I should see the following "My List" tasks in order:
      | Something else    |
      | One more thing    |
      | And another thing |
      | Something         |
      | Finished          |
