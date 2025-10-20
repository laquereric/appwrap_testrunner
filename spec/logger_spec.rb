require "spec_helper"

RSpec.describe Appwrap::Testrunner::Logger do
  let(:test_dir) { File.join(Appwrap::Testrunner::BASE_DIR, "test-logger") }
  let(:logger) { described_class.new(test_dir) }

  before do
    FileUtils.mkdir_p(test_dir)
  end

  describe "#log" do
    it "creates a log entry with timestamp" do
      entry = logger.log(:info, "Test message", { key: "value" })
      
      expect(entry[:level]).to eq("info")
      expect(entry[:message]).to eq("Test message")
      expect(entry[:metadata]).to eq({ key: "value" })
      expect(entry[:timestamp]).to be_a(String)
    end

    it "adds entry to log_entries array" do
      logger.log(:info, "Message 1")
      logger.log(:warn, "Message 2")
      
      expect(logger.log_entries.count).to eq(2)
    end
  end

  describe "#info" do
    it "logs an info level message" do
      entry = logger.info("Info message")
      expect(entry[:level]).to eq("info")
      expect(entry[:message]).to eq("Info message")
    end
  end

  describe "#warn" do
    it "logs a warning level message" do
      entry = logger.warn("Warning message")
      expect(entry[:level]).to eq("warn")
      expect(entry[:message]).to eq("Warning message")
    end
  end

  describe "#error" do
    it "logs an error level message" do
      entry = logger.error("Error message")
      expect(entry[:level]).to eq("error")
      expect(entry[:message]).to eq("Error message")
    end
  end

  describe "#debug" do
    it "logs a debug level message" do
      entry = logger.debug("Debug message")
      expect(entry[:level]).to eq("debug")
      expect(entry[:message]).to eq("Debug message")
    end
  end

  describe "#finalize" do
    it "writes log entries to test_log.json" do
      logger.info("Message 1")
      logger.warn("Message 2")
      logger.error("Message 3")
      logger.finalize
      
      log_file = File.join(test_dir, "test_log.json")
      expect(File.exist?(log_file)).to be true
      
      data = JSON.parse(File.read(log_file), symbolize_names: true)
      expect(data[:total_entries]).to eq(3)
      expect(data[:entries].count).to eq(3)
    end
  end
end

