require_relative "appwrap/testrunner/version"
require_relative "appwrap/testrunner/runner"
require_relative "appwrap/testrunner/logger"
require_relative "appwrap/testrunner/test_executor"

module Appwrap
  module Testrunner
    class Error < StandardError; end

    # Base directory for all test runs
    BASE_DIR = "appwrap/testrun"

    class << self
      # Execute a test with the given UUID
      # @param test_uuid [String] Unique identifier for the test run
      # @param test_block [Proc] The test code to execute
      # @return [Hash] Test execution results
      def run(test_uuid, &test_block)
        Runner.new(test_uuid).execute(&test_block)
      end

      # Get the path for a specific test run
      # @param test_uuid [String] Unique identifier for the test run
      # @return [String] Full path to the test run directory
      def test_path(test_uuid)
        File.join(BASE_DIR, test_uuid)
      end
    end
  end
end

