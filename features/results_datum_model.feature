Feature: ResultsDatum model
  Scenario: Valid model of ResultsDatum
    Given valid ResultsDatum model
    Then check presense of subject
    Then check presense of timestamp
    Then check presense of marks