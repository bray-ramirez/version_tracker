# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "version_tracker"
  spec.version       = VersionTracker::VERSION
  spec.authors       = ["Braymon Ramirez"]
  spec.email         = ["braymon.ramirez@gmail.com"]
  spec.summary       = "Provides command line and rake tasks to bump versions of your Rails Applications"
  spec.description   = "Add Version to your Rails Application"
  spec.homepage      = "https://github.com/brayramirez/version_tracker"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb", "bin/*", "LICENSE", "*.md", "lib/tasks/*.rake"]
  spec.executables   = ['version']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.2.0'
end
