require "spec_helper"

RSpec.describe Appwrap::Testrunner::TestExecutor do
  let(:test_dir) { File.join(Appwrap::Testrunner::BASE_DIR, "test-executor") }
  let(:logger) { Appwrap::Testrunner::Logger.new(test_dir) }
  let(:executor) { described_class.new(logger) }

  before do
    FileUtils.mkdir_p(test_dir)
  end

  describe "#execute" do
    it "executes a test block and returns result" do
      result = executor.execute do |exec|
        { test: "result", value: 123 }
      end

      expect(result).to eq({ test: "result", value: 123 })
    end

    it "measures execution duration" do
      executor.execute do |exec|
        sleep 0.1
      end

      expect(executor.duration_ms).to be > 90
      expect(executor.duration_ms).to be < 200
    end

    it "logs debug message when executing" do
      executor.execute { |exec| "result" }
      
      debug_logs = logger.log_entries.select { |e| e[:level] == "debug" }
      expect(debug_logs).not_to be_empty
      expect(debug_logs.first[:message]).to eq("Executing test block")
    end
  end

  describe "#log" do
    it "logs a custom message through the logger" do
      executor.log("Custom message", { data: "value" })
      
      expect(logger.log_entries.count).to eq(1)
      expect(logger.log_entries.first[:message]).to eq("Custom message")
      expect(logger.log_entries.first[:metadata]).to eq({ data: "value" })
    end
  end

  describe "#step" do
    it "executes a step and logs start and completion" do
      result = executor.execute do |exec|
        exec.step("Test step") do
          { step_result: true }
        end
      end

      expect(result).to eq({ step_result: true })
      
      step_logs = logger.log_entries.select { |e| e[:message].include?("Test step") }
      expect(step_logs.count).to eq(2) # Start and completion
    end

    it "logs step duration" do
      executor.execute do |exec|
        exec.step("Timed step") do
          sleep 0.05
          "result"
        end
      end

      completion_log = logger.log_entries.find { |e| e[:message].include?("Completed step") }
      expect(completion_log[:metadata][:duration_ms]).to be > 40
    end

    it "logs step failure and re-raises error" do
      expect do
        executor.execute do |exec|
          exec.step("Failing step") do
            raise StandardError, "Step failed"
          end
        end
      end.to raise_error(StandardError, "Step failed")

      failure_log = logger.log_entries.find { |e| e[:message].include?("Failed step") }
      expect(failure_log).not_to be_nil
      expect(failure_log[:metadata][:error]).to eq("Step failed")
    end
  end
end

