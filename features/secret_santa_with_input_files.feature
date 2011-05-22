Feature: Secret-Santa organizer inputs a list of participants

  As a secret-santa organizer
  I want to input a list of participants as input files
  So that I can create a list of secret-santa to participant matches

  Scenario: input file contains one participant
    Given a file named "input_file.dat" with:
      """
      Leia Skywalker   <leia@therebellion.org>
      """
    When I run `secret_santa input_file.dat`
    Then it should fail with:
      """
      secret_santa: Input needs at least 2 entries
      """

  Scenario: input file contains two participants in the wrong format
    Given a file named "input_file.dat" with:
      """
      Leia   <leia@therebellion.org>
      Toula  <toula@manhunter.org>
      """
    When I run `secret_santa input_file.dat`
    Then it should fail with:
      """
      secret_santa: Participants must be entered in the following format: FIRST_NAME LAST_NAME <EMAIL_ADDRESS>
      """

  Scenario: input file contains two participants which can match
    Given a file named "input_file.dat" with:
      """
      Leia Skywalker   <leia@therebellion.org>
      Toula Portokalos <toula@manhunter.org>
      """
    When I run `secret_santa input_file.dat`
    Then the output should match /Leia Skywalker <leia@therebellion.org>\s+=>\s+Toula Portokalos/
    And the output should match /Toula Portokalos <toula@manhunter.org>\s+=>\s+Leia Skywalker/

  Scenario: input file contains two participants which cannot match
    Given a file named "input_file.dat" with:
      """
      Leia Skywalker   <leia@therebellion.org>
      Luke Skywalker <luke@therebellion.org>
      """
    When I run `secret_santa input_file.dat`
    Then it should fail with:
      """
      secret_santa: No potential matches found for
      """

  Scenario: two input files are specified, with participants which can match
    Given a file named "input_file_1.dat" with:
      """
      Leia Skywalker   <leia@therebellion.org>
      """
    And a file named "input_file_2.dat" with:
      """
      Toula Portokalos <toula@manhunter.org>
      """
    When I run `secret_santa input_file_1.dat input_file_2.dat`
    Then the output should match /Leia Skywalker <leia@therebellion.org>\s+=>\s+Toula Portokalos/
    And the output should match /Toula Portokalos <toula@manhunter.org>\s+=>\s+Leia Skywalker/

  Scenario: two input files are specified, with participants which cannot match
    Given a file named "input_file_1.dat" with:
      """
      Leia Skywalker   <leia@therebellion.org>
      """
    And a file named "input_file_2.dat" with:
      """
      Luke Skywalker <luke@therebellion.org>
      """
    When I run `secret_santa input_file_1.dat input_file_2.dat`
    Then it should fail with:
      """
      secret_santa: No potential matches found for
      """
