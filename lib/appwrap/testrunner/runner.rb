require 'fileutils'
require 'json'
require 'securerandom'
require 'time'

module Appwrap
  module Testrunner
    class Runner
      attr_reader :test_uuid, :test_dir

      def initialize(test_uuid)
        @test_uuid = test_uuid
        @test_dir = File.join(Appwrap::Testrunner::BASE_DIR, test_uuid)
        setup_test_directory
      end

      # Execute the test and capture all outputs
      # @param test_block [Proc] The test code to execute
      # @return [Hash] Test execution results
      def execute(&test_block)
        raise ArgumentError, "No test block provided" unless block_given?

        test_call = capture_test_call
        logger = Logger.new(@test_dir)
        
        begin
          logger.log(:info, "Starting test execution", { test_uuid: @test_uuid })
          
          # Execute the test
          executor = TestExecutor.new(logger)
          result = executor.execute(&test_block)
          
          test_response = {
            test_uuid: @test_uuid,
            status: "success",
            result: result,
            executed_at: Time.now.iso8601,
            duration_ms: executor.duration_ms
          }
          
          logger.log(:info, "Test execution completed successfully", { duration_ms: executor.duration_ms })
        rescue => e
          test_response = {
            test_uuid: @test_uuid,
            status: "error",
            error: {
              message: e.message,
              class: e.class.name,
              backtrace: e.backtrace&.first(10)
            },
            executed_at: Time.now.iso8601,
            duration_ms: executor&.duration_ms
          }
          
          logger.log(:error, "Test execution failed", { error: e.message, class: e.class.name })
        ensure
          # Write all output files
          write_json_file("test_call.json", test_call)
          write_json_file("test_response.json", test_response)
          logger.finalize
        end

        test_response
      end

      private

      def setup_test_directory
        FileUtils.mkdir_p(@test_dir)
      end

      def capture_test_call
        {
          test_uuid: @test_uuid,
          called_at: Time.now.iso8601,
          ruby_version: RUBY_VERSION,
          gem_version: Appwrap::Testrunner::VERSION,
          working_directory: Dir.pwd,
          environment: {
            rails_env: ENV['RAILS_ENV'],
            rack_env: ENV['RACK_ENV']
          }
        }
      end

      def write_json_file(filename, data)
        file_path = File.join(@test_dir, filename)
        File.write(file_path, JSON.pretty_generate(data))
      end
    end
  end
end

