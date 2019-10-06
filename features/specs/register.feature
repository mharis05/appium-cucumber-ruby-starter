Feature: Register as a new user
  Actors:
  - A potential user
  - System
  Use Case:
  A potential user attempts to register as a new user using
  the app.

  @android
  Scenario: Successful Registration
    Given user is on the registration page
    When user enters "valid" details in registration form
    Then system creates an account for the user

  Scenario Outline: Unsuccessful attempt for registration
    Given a user with "valid" email
    When user enters "invalid" <value> in registration form
    Then system shows an error message for <value>
    And system does not create an account
    Examples:
      | value |
      | Name  |
      | Email |
