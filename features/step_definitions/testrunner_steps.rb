Given('I have a test UUID {string}') do |test_uuid|
  @test_uuid = test_uuid
  @test_uuids << test_uuid
end

When('I run the test') do
  @result = Appwrap::Testrunner.run(@test_uuid) do |executor|
    executor.log("Starting test execution")
    
    executor.step("Setup") do
      { setup: "complete" }
    end
    
    executor.step("Execute") do
      { execution: "success", value: 42 }
    end
    
    executor.log("Test execution completed")
    { success: true }
  end
end

When('I run a failing test') do
  @result = Appwrap::Testrunner.run(@test_uuid) do |executor|
    executor.log("Starting failing test")
    raise StandardError, "Intentional test failure"
  end
end

Then('the test should complete successfully') do
  expect(@result[:status]).to eq("success")
end

Then('the test should fail with an error') do
  expect(@result[:status]).to eq("error")
  expect(@result[:error][:message]).to eq("Intentional test failure")
end

Then('a test directory should be created') do
  test_path = Appwrap::Testrunner.test_path(@test_uuid)
  expect(Dir.exist?(test_path)).to be true
end

Then('the directory should contain {string}') do |filename|
  test_path = Appwrap::Testrunner.test_path(@test_uuid)
  file_path = File.join(test_path, filename)
  expect(File.exist?(file_path)).to be true
end

Then('the {string} file should contain valid JSON') do |filename|
  test_path = Appwrap::Testrunner.test_path(@test_uuid)
  file_path = File.join(test_path, filename)
  content = File.read(file_path)
  
  expect { JSON.parse(content) }.not_to raise_error
end

Then('the {string} file should have a {string} field') do |filename, field|
  test_path = Appwrap::Testrunner.test_path(@test_uuid)
  file_path = File.join(test_path, filename)
  data = JSON.parse(File.read(file_path), symbolize_names: true)
  
  expect(data.key?(field.to_sym)).to be true
end

Then('the test_response should indicate success') do
  test_path = Appwrap::Testrunner.test_path(@test_uuid)
  file_path = File.join(test_path, "test_response.json")
  data = JSON.parse(File.read(file_path), symbolize_names: true)
  
  expect(data[:status]).to eq("success")
end

Then('the test_response should indicate error') do
  test_path = Appwrap::Testrunner.test_path(@test_uuid)
  file_path = File.join(test_path, "test_response.json")
  data = JSON.parse(File.read(file_path), symbolize_names: true)
  
  expect(data[:status]).to eq("error")
  expect(data[:error]).not_to be_nil
end

Then('the test_log should contain log entries') do
  test_path = Appwrap::Testrunner.test_path(@test_uuid)
  file_path = File.join(test_path, "test_log.json")
  data = JSON.parse(File.read(file_path), symbolize_names: true)
  
  expect(data[:total_entries]).to be > 0
  expect(data[:entries]).to be_an(Array)
  expect(data[:entries].count).to eq(data[:total_entries])
end

