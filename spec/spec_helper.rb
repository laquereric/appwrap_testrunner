require "appwrap/testrunner"
require "fileutils"
require "json"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Clean up test directories after each test
  config.after(:each) do
    base_dir = Appwrap::Testrunner::BASE_DIR
    FileUtils.rm_rf(base_dir) if Dir.exist?(base_dir)
  end
end

