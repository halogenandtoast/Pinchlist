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
