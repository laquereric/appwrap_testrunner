require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber)

task default: [:spec, :cucumber]

# Load the gem's rake tasks
require_relative 'lib/appwrap/testrunner'

namespace :appwrap do
  namespace :testrunner do
    desc "Run a test with the given UUID"
    task :run, [:test_uuid] do |t, args|
      test_uuid = args[:test_uuid] || raise("test_uuid is required")
      
      puts "Running test with UUID: #{test_uuid}"
      
      # Execute a sample test
      result = Appwrap::Testrunner.run(test_uuid) do |executor|
        executor.log("Test execution started")
        
        # Sample test logic
        executor.step("Initialize test environment") do
          sleep 0.1
          { initialized: true }
        end
        
        executor.step("Execute main test logic") do
          sleep 0.2
          { test_data: "sample", value: 42 }
        end
        
        executor.step("Cleanup") do
          sleep 0.05
          { cleanup: "complete" }
        end
        
        executor.log("Test execution completed")
        
        { success: true, message: "Test completed successfully" }
      end
      
      puts "\nTest execution completed!"
      puts "Status: #{result[:status]}"
      puts "Output directory: #{Appwrap::Testrunner.test_path(test_uuid)}"
      puts "\nGenerated files:"
      puts "  - test_call.json"
      puts "  - test_response.json"
      puts "  - test_log.json"
    end

    desc "Clean all test run directories"
    task :clean do
      base_dir = Appwrap::Testrunner::BASE_DIR
      if Dir.exist?(base_dir)
        FileUtils.rm_rf(Dir.glob(File.join(base_dir, "*")))
        puts "Cleaned all test runs from #{base_dir}"
      else
        puts "No test runs to clean"
      end
    end

    desc "List all test runs"
    task :list do
      base_dir = Appwrap::Testrunner::BASE_DIR
      if Dir.exist?(base_dir)
        test_runs = Dir.glob(File.join(base_dir, "*")).select { |f| File.directory?(f) }
        if test_runs.any?
          puts "Test runs found:"
          test_runs.each do |dir|
            uuid = File.basename(dir)
            puts "  - #{uuid}"
          end
        else
          puts "No test runs found"
        end
      else
        puts "No test runs directory exists"
      end
    end
  end
end

