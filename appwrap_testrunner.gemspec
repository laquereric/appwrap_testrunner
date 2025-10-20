require_relative 'lib/appwrap/testrunner/version'

Gem::Specification.new do |spec|
  spec.name          = "appwrap_testrunner"
  spec.version       = Appwrap::Testrunner::VERSION
  spec.authors       = ["Appwrap Team"]
  spec.email         = ["team@appwrap.io"]

  spec.summary       = "Test execution framework with structured JSON logging"
  spec.description   = "A Ruby gem that runs tests and captures logs in structured JSON format within isolated UUID-based directories"
  spec.homepage      = "https://github.com/appwrap/testrunner"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/appwrap/testrunner"
  spec.metadata["changelog_uri"] = "https://github.com/appwrap/testrunner/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "cucumber", "~> 9.0"
  spec.add_development_dependency "json-schema", "~> 4.0"
end

