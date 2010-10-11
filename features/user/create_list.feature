Feature: In order to manage my tasks
  As a user
  I want to create a list

  @javascript
  Scenario: Adding a list
    Given I am signed in as "user@example.com/password"
    When I fill in the list title with "My List"
    And I submit the new list form
    Then I should see the list "My List"
