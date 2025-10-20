require "spec_helper"

RSpec.describe Appwrap::Testrunner::Runner do
  let(:test_uuid) { "test-#{SecureRandom.uuid}" }
  let(:runner) { described_class.new(test_uuid) }

  describe "#initialize" do
    it "creates a test directory" do
      expect(Dir.exist?(runner.test_dir)).to be true
    end

    it "sets the test UUID" do
      expect(runner.test_uuid).to eq(test_uuid)
    end
  end

  describe "#execute" do
    it "executes a test block successfully" do
      result = runner.execute do |executor|
        { success: true, value: 42 }
      end

      expect(result[:status]).to eq("success")
      expect(result[:result]).to eq({ success: true, value: 42 })
      expect(result[:test_uuid]).to eq(test_uuid)
    end

    it "captures test execution errors" do
      result = runner.execute do |executor|
        raise StandardError, "Test error"
      end

      expect(result[:status]).to eq("error")
      expect(result[:error][:message]).to eq("Test error")
      expect(result[:error][:class]).to eq("StandardError")
    end

    it "creates test_call.json file" do
      runner.execute { |executor| { success: true } }
      
      file_path = File.join(runner.test_dir, "test_call.json")
      expect(File.exist?(file_path)).to be true
      
      data = JSON.parse(File.read(file_path), symbolize_names: true)
      expect(data[:test_uuid]).to eq(test_uuid)
      expect(data[:gem_version]).to eq(Appwrap::Testrunner::VERSION)
    end

    it "creates test_response.json file" do
      runner.execute { |executor| { success: true } }
      
      file_path = File.join(runner.test_dir, "test_response.json")
      expect(File.exist?(file_path)).to be true
      
      data = JSON.parse(File.read(file_path), symbolize_names: true)
      expect(data[:status]).to eq("success")
      expect(data[:test_uuid]).to eq(test_uuid)
    end

    it "creates test_log.json file" do
      runner.execute { |executor| { success: true } }
      
      file_path = File.join(runner.test_dir, "test_log.json")
      expect(File.exist?(file_path)).to be true
      
      data = JSON.parse(File.read(file_path), symbolize_names: true)
      expect(data[:total_entries]).to be > 0
      expect(data[:entries]).to be_an(Array)
    end

    it "measures execution duration" do
      result = runner.execute do |executor|
        sleep 0.1
        { success: true }
      end

      expect(result[:duration_ms]).to be > 90
      expect(result[:duration_ms]).to be < 200
    end

    it "raises error when no block is provided" do
      expect { runner.execute }.to raise_error(ArgumentError, "No test block provided")
    end
  end
end

