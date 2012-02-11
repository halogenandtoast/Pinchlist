@selenium
Feature: User upgrades account

  Scenario: Can add more than 3 lists
    Given I am signed in as "user@example.com/password"
    And I have 3 lists
    Then I can not create another list
    When I upgrade my account
    Then I can create another list
