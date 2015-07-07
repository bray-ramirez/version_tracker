require 'version_tracker/version'
require 'version_tracker/bumper'
require 'version_tracker/file_manager'

module VersionTracker

  require 'version_tracker/railtie' if defined?(Rails)

end
