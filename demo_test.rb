require_relative 'lib/appwrap/testrunner'
require 'securerandom'

test_uuid = "demo-#{SecureRandom.uuid}"

puts "=" * 60
puts "Appwrap Testrunner Demo"
puts "=" * 60
puts "Test UUID: #{test_uuid}"
puts

result = Appwrap::Testrunner.run(test_uuid) do |executor|
  executor.log("Demo test started", { demo: true })
  
  executor.step("Initialize test environment") do
    sleep 0.1
    { initialized: true, timestamp: Time.now.iso8601 }
  end
  
  executor.step("Execute main test logic") do
    sleep 0.15
    data = {
      test_type: "demo",
      calculations: [1, 2, 3, 4, 5].sum,
      random_value: rand(100)
    }
    executor.log("Calculations completed", data)
    data
  end
  
  executor.step("Validate results") do
    sleep 0.05
    { validation: "passed", checks: 3 }
  end
  
  executor.log("Demo test completed successfully")
  
  { 
    success: true, 
    message: "Demo test executed successfully",
    total_steps: 3
  }
end

puts "\n" + "=" * 60
puts "Test Execution Complete"
puts "=" * 60
puts "Status: #{result[:status]}"
puts "Duration: #{result[:duration_ms]}ms"
puts "Output directory: #{Appwrap::Testrunner.test_path(test_uuid)}"
puts

# Display the generated files
test_path = Appwrap::Testrunner.test_path(test_uuid)
puts "\nGenerated Files:"
puts "-" * 60

Dir.glob(File.join(test_path, "*.json")).sort.each do |file|
  puts "\n📄 #{File.basename(file)}"
  puts "-" * 60
  puts File.read(file)
end

puts "\n" + "=" * 60
