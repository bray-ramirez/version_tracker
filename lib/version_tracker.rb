require 'version_tracker/version'
require 'version_tracker/bumper'
require 'version_tracker/file_manager'

module VersionTracker

  require 'my_plugin/railtie' if defined?(Rails)

end
