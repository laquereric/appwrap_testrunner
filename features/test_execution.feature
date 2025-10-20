Feature: Test Execution
  As a developer
  I want to run tests with structured logging
  So that I can capture and analyze test execution details

  Scenario: Successfully execute a test
    Given I have a test UUID "successful-test-001"
    When I run the test
    Then the test should complete successfully
    And a test directory should be created
    And the directory should contain "test_call.json"
    And the directory should contain "test_response.json"
    And the directory should contain "test_log.json"

  Scenario: Execute a failing test
    Given I have a test UUID "failing-test-001"
    When I run a failing test
    Then the test should fail with an error
    And a test directory should be created
    And the directory should contain "test_call.json"
    And the directory should contain "test_response.json"
    And the directory should contain "test_log.json"

  Scenario: Verify test_call.json structure
    Given I have a test UUID "test-call-check-001"
    When I run the test
    Then the "test_call.json" file should contain valid JSON
    And the "test_call.json" file should have a "test_uuid" field
    And the "test_call.json" file should have a "called_at" field
    And the "test_call.json" file should have a "gem_version" field

  Scenario: Verify test_response.json structure
    Given I have a test UUID "test-response-check-001"
    When I run the test
    Then the "test_response.json" file should contain valid JSON
    And the "test_response.json" file should have a "test_uuid" field
    And the "test_response.json" file should have a "status" field
    And the "test_response.json" file should have a "executed_at" field
    And the test_response should indicate success

  Scenario: Verify test_log.json structure
    Given I have a test UUID "test-log-check-001"
    When I run the test
    Then the "test_log.json" file should contain valid JSON
    And the "test_log.json" file should have a "total_entries" field
    And the "test_log.json" file should have a "entries" field
    And the test_log should contain log entries

