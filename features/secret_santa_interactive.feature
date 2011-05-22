Feature: Secret-Santa organizer inputs a list of participants interactively

  As a secret-santa organizer
  I want to input a list of participants interactively
  So that I can create a list of secret-santa to participant matches

  Scenario: interactive interface prompts for input
    When I run `secret_santa` interactively
    And I type "Leia Skywalker   <leia@therebellion.org>"
    And I type "Toula Portokalos <toula@manhunter.org>"
    And I type "Done"
    Then the output should contain:
      """
      Enter participants in the following format:
        Luke Skywalker <luke@theforce.net>
      enter 'Done' on a line by itself when you are done
      """

  Scenario: interactively enter one participant
    When I run `secret_santa` interactively
    And I type "Toula Portokalos <toula@manhunter.org>"
    And I type "Done"
    Then it should fail with:
      """
      secret_santa: Input needs at least 2 entries
      """

  Scenario: interactively enter two participants in the wrong format
    When I run `secret_santa` interactively
    And I type "Leia   <leia@therebellion.org>"
    And I type "Toula <toula@manhunter.org>"
    And I type "Done"
    Then it should fail with:
      """
      secret_santa: Participants must be entered in the following format: FIRST_NAME LAST_NAME <EMAIL_ADDRESS>
      """

  Scenario: interactively enter two participants which can match
    When I run `secret_santa` interactively
    And I type "Leia Skywalker   <leia@therebellion.org>"
    And I type "Toula Portokalos <toula@manhunter.org>"
    And I type "Done"
    Then the output should match /Leia Skywalker <leia@therebellion.org>\s+=>\s+Toula Portokalos/
    And the output should match /Toula Portokalos <toula@manhunter.org>\s+=>\s+Leia Skywalker/

  Scenario: interactively enter two participants which cannot match
    When I run `secret_santa` interactively
    And I type "Luke Skywalker   <luke@theforce.net>"
    And I type "Leia Skywalker   <leia@therebellion.org>"
    And I type "Done"
    Then it should fail with:
      """
      secret_santa: No potential matches found for
      """
