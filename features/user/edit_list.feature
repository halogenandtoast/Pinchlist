Feature: Edit a list
  In order to change details about a list
  As a user
  I want to click and edit the title or reorder the list

  @javascript
  Scenario: Renaming a list
    Given I am signed in as "user@example.com/password"
    And the following list exists:
      | title   | user                    |
      | My List | email: user@example.com |
    When I go to the dashboard page
    And I double click the list title "My List"
    And I fill in the list title for "My List" with "My Really Awesome List"
    And I submit the list title form for "My List"
    Then I should see the list "My Really Awesome List"
    When I go to the dashboard page
    Then I should see the list "My Really Awesome List"

  @javascript
  Scenario: Reordering a list
    Given I am signed in as "user@example.com/password"
    And the following lists exist:
      | title         | user                    | position |
      | My List       | email: user@example.com | 1        |
      | My Other List | email: user@example.com | 2        |
    When I go to the dashboard page
    And I drag the list "My List" over "My Other List"
    When I go to the dashboard page
    Then I should see the list "My Other List" before "My List"

  @javascript
  Scenario: Changing the color of a list
    Given today is "October 16, 2010"
    And I am signed in as "user@example.com/password"
    And the following lists exist:
      | title   | user                    | color  |
      | My List | email: user@example.com | 009000 |
    And the following task exists:
      | list           | title   | due date   |
      | title: My List | My Task | 2010-10-20 |
    When I go to the dashboard page
    Then the list "My List" should have the color "009000"
    And I see the upcoming task "My Task" has a due date color of "009000"
    When I change the color of "My List" to "990099"
    And I see the upcoming task "My Task" has a due date color of "990099"

