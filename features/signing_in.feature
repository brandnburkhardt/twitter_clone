Feature: Signing In

  Scenario: Unsuccessful Sign In
    Given a user visits the signin page
    When the user submits invalid signin information
    Then the user should see an error message

  Scenario: Successful Sign In
    Given a user visits the signin page
    And the user has an account
    When the user submits valid signin information
    Then the user should see their profile page
    And the user should see a signout link