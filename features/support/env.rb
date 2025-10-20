require "appwrap/testrunner"
require "fileutils"
require "json"

# Clean up test directories before and after scenarios
Before do
  @test_uuids = []
end

After do
  base_dir = Appwrap::Testrunner::BASE_DIR
  FileUtils.rm_rf(base_dir) if Dir.exist?(base_dir)
end

