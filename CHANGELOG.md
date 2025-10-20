# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-10-20

### Added
- Initial release of appwrap_testrunner gem
- Test execution framework with UUID-based isolation
- Structured JSON logging (test_call.json, test_response.json, test_log.json)
- Runner class for managing test execution
- Logger class for structured log capture
- TestExecutor class with step-based execution support
- Rake tasks for running, listing, and cleaning test runs
- Comprehensive RSpec test suite
- Cucumber integration tests
- Full documentation and README

### Features
- Isolated test run directories under appwrap/testrun/
- Automatic capture of test calls, responses, and logs
- Error handling and detailed error reporting
- Execution duration tracking
- Step-based test execution with individual step timing
- Multiple log levels (info, warn, error, debug)

