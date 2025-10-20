require "spec_helper"

RSpec.describe Appwrap::Testrunner do
  it "has a version number" do
    expect(Appwrap::Testrunner::VERSION).not_to be nil
  end

  describe ".run" do
    let(:test_uuid) { "integration-test-#{SecureRandom.uuid}" }

    it "executes a test with the given UUID" do
      result = Appwrap::Testrunner.run(test_uuid) do |executor|
        executor.log("Test started")
        { success: true, data: "test data" }
      end

      expect(result[:status]).to eq("success")
      expect(result[:result]).to eq({ success: true, data: "test data" })
      expect(result[:test_uuid]).to eq(test_uuid)
    end

    it "creates the test directory structure" do
      Appwrap::Testrunner.run(test_uuid) { |executor| { success: true } }
      
      test_path = Appwrap::Testrunner.test_path(test_uuid)
      expect(Dir.exist?(test_path)).to be true
    end

    it "creates all required JSON files" do
      Appwrap::Testrunner.run(test_uuid) { |executor| { success: true } }
      
      test_path = Appwrap::Testrunner.test_path(test_uuid)
      expect(File.exist?(File.join(test_path, "test_call.json"))).to be true
      expect(File.exist?(File.join(test_path, "test_response.json"))).to be true
      expect(File.exist?(File.join(test_path, "test_log.json"))).to be true
    end
  end

  describe ".test_path" do
    it "returns the correct path for a test UUID" do
      test_uuid = "my-test-uuid"
      expected_path = File.join(Appwrap::Testrunner::BASE_DIR, test_uuid)
      
      expect(Appwrap::Testrunner.test_path(test_uuid)).to eq(expected_path)
    end
  end

  describe "BASE_DIR" do
    it "is set to appwrap/testrun" do
      expect(Appwrap::Testrunner::BASE_DIR).to eq("appwrap/testrun")
    end
  end
end

