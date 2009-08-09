Feature: Access Aplication
  In order to access to the application
  As and admin, exhibitor, buyer ir extenda user
  I want to access to my private zone depending of my role

  Scenario: Admin Login
    When I go to the website home
    And I fill in login with admin
    And I fill in password with sabor86
    And I press "ENVIAR"
    Then I should see "Bienvenido Admin"
