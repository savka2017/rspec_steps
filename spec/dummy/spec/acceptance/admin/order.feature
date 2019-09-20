Feature: Create order
  Scenario: Admin creates new order
    Given I am logged in as Admin
    When I visit order page
    Then I can create new order
