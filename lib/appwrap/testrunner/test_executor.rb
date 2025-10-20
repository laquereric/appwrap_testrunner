module Appwrap
  module Testrunner
    class TestExecutor
      attr_reader :duration_ms, :logger

      def initialize(logger)
        @logger = logger
        @duration_ms = 0
      end

      # Execute the test block and measure duration
      # @param test_block [Proc] The test code to execute
      # @return [Object] Result of the test block execution
      def execute(&test_block)
        start_time = Time.now
        
        @logger.debug("Executing test block")
        result = test_block.call(self)
        
        end_time = Time.now
        @duration_ms = ((end_time - start_time) * 1000).round(2)
        
        result
      end

      # Helper method for tests to log custom messages
      def log(message, metadata = {})
        @logger.info(message, metadata)
      end

      # Helper method to capture step execution
      def step(step_name, &block)
        @logger.info("Starting step: #{step_name}")
        step_start = Time.now
        
        begin
          result = block.call
          step_duration = ((Time.now - step_start) * 1000).round(2)
          @logger.info("Completed step: #{step_name}", { duration_ms: step_duration })
          result
        rescue => e
          step_duration = ((Time.now - step_start) * 1000).round(2)
          @logger.error("Failed step: #{step_name}", { 
            duration_ms: step_duration,
            error: e.message 
          })
          raise
        end
      end
    end
  end
end

