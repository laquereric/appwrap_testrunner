# Appwrap::Testrunner

A Ruby gem for executing tests with structured JSON logging and isolated test run directories.

## Overview

**appwrap_testrunner** provides a framework for running tests while capturing detailed execution logs, test calls, and responses in structured JSON format. Each test run is isolated in its own UUID-based directory under `appwrap/testrun/`.

## Features

- **Isolated Test Runs**: Each test execution creates a unique directory based on UUID
- **Structured Logging**: Captures logs in JSON format with timestamps and metadata
- **Test Execution Tracking**: Records test calls, responses, and execution duration
- **Step-based Execution**: Support for breaking tests into logged steps
- **Error Handling**: Captures and logs test failures with full error details
- **Rake Tasks**: Convenient rake tasks for running and managing tests

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'appwrap_testrunner'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install appwrap_testrunner
```

## Usage

### Basic Test Execution

```ruby
require 'appwrap/testrunner'

test_uuid = "my-test-#{SecureRandom.uuid}"

result = Appwrap::Testrunner.run(test_uuid) do |executor|
  executor.log("Starting test")
  
  # Your test logic here
  { success: true, data: "test result" }
end

puts "Test status: #{result[:status]}"
puts "Test directory: #{Appwrap::Testrunner.test_path(test_uuid)}"
```

### Step-based Execution

```ruby
Appwrap::Testrunner.run(test_uuid) do |executor|
  executor.step("Initialize environment") do
    # Setup code
    { initialized: true }
  end
  
  executor.step("Execute main logic") do
    # Test logic
    { result: "success" }
  end
  
  executor.step("Cleanup") do
    # Cleanup code
    { cleaned: true }
  end
end
```

### Using Rake Tasks

Run a test with a specific UUID:

```bash
$ rake appwrap:testrunner:run[my-test-uuid]
```

List all test runs:

```bash
$ rake appwrap:testrunner:list
```

Clean all test run directories:

```bash
$ rake appwrap:testrunner:clean
```

## Output Structure

Each test run creates a directory at `appwrap/testrun/{UUID}/` containing three JSON files:

### test_call.json

Contains information about the test invocation:

```json
{
  "test_uuid": "my-test-uuid",
  "called_at": "2025-10-20T12:00:00Z",
  "ruby_version": "3.3.6",
  "gem_version": "0.1.0",
  "working_directory": "/path/to/project",
  "environment": {
    "rails_env": "test",
    "rack_env": null
  }
}
```

### test_response.json

Contains the test execution result:

```json
{
  "test_uuid": "my-test-uuid",
  "status": "success",
  "result": {
    "success": true,
    "data": "test result"
  },
  "executed_at": "2025-10-20T12:00:01Z",
  "duration_ms": 123.45
}
```

Or in case of failure:

```json
{
  "test_uuid": "my-test-uuid",
  "status": "error",
  "error": {
    "message": "Test failed",
    "class": "StandardError",
    "backtrace": ["line 1", "line 2"]
  },
  "executed_at": "2025-10-20T12:00:01Z",
  "duration_ms": 45.67
}
```

### test_log.json

Contains detailed execution logs:

```json
{
  "total_entries": 5,
  "entries": [
    {
      "timestamp": "2025-10-20T12:00:00Z",
      "level": "info",
      "message": "Starting test execution",
      "metadata": {
        "test_uuid": "my-test-uuid"
      }
    },
    {
      "timestamp": "2025-10-20T12:00:00Z",
      "level": "info",
      "message": "Starting step: Initialize environment",
      "metadata": {}
    }
  ]
}
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

Run the test suite:

```bash
$ bundle exec rake spec
```

Run Cucumber features:

```bash
$ bundle exec rake cucumber
```

Run all tests:

```bash
$ bundle exec rake
```

## Testing

The gem includes comprehensive test coverage using both RSpec and Cucumber:

- **RSpec**: Unit tests for all core classes
- **Cucumber**: Integration tests for end-to-end scenarios

## Requirements

- Ruby >= 3.3.6
- No external dependencies for core functionality

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appwrap/testrunner.

