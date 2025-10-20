require 'json'
require 'time'

module Appwrap
  module Testrunner
    class Logger
      attr_reader :log_entries

      def initialize(test_dir)
        @test_dir = test_dir
        @log_entries = []
        @log_file = File.join(@test_dir, "test_log.json")
      end

      # Log a message with level and metadata
      # @param level [Symbol] Log level (:info, :warn, :error, :debug)
      # @param message [String] Log message
      # @param metadata [Hash] Additional metadata
      def log(level, message, metadata = {})
        entry = {
          timestamp: Time.now.iso8601,
          level: level.to_s,
          message: message,
          metadata: metadata
        }
        
        @log_entries << entry
        entry
      end

      # Log info level message
      def info(message, metadata = {})
        log(:info, message, metadata)
      end

      # Log warning level message
      def warn(message, metadata = {})
        log(:warn, message, metadata)
      end

      # Log error level message
      def error(message, metadata = {})
        log(:error, message, metadata)
      end

      # Log debug level message
      def debug(message, metadata = {})
        log(:debug, message, metadata)
      end

      # Finalize and write log entries to file
      def finalize
        log_data = {
          total_entries: @log_entries.count,
          entries: @log_entries
        }
        
        File.write(@log_file, JSON.pretty_generate(log_data))
      end
    end
  end
end

