#
#
# Reference:
#   http://semver.org/
#
#

require 'errors/version_tracker_error'
require 'version_tracker/file_manager'


module VersionTracker

  class Bumper

    attr_accessor :parts


    DELIMITER = '.'
    INITIAL_VERSION = '0.0.0'
    BASIC_FORMAT = /^\d+\.\d+\.\d+$/


    module PARTS
      MAJOR = 0
      MINOR = 1
      PATCH = 2
    end


    def init version = nil
      raise VersionTrackerError, 'Version format is invalid' if version && !(BASIC_FORMAT =~ version)

      FileManager.write(version || INITIAL_VERSION)
    end


    #
    #
    # Options:
    #   :part
    #   :value
    #
    #
    def bump options = {}
      raise VersionTrackerError, 'Version File is not initialized' unless FileManager.initialized?

      part = options[:part] || :patch

      unless [:major, :minor, :patch].include?(part)
        raise VersionTrackerError, 'Invalid Part Parameter.'
      end


      value = options[:value]
      if value && !value.is_a?(Integer)
        raise VersionTrackerError, 'Value should be of Integer Type'
      end

      self.send "bump_#{part}".to_sym, value
    end


    def version
      raise VersionTrackerError, 'Version File is not initialized' unless FileManager.initialized?

      FileManager.read
    end


    def parts
      version_parts = self.version.split DELIMITER

      hash = {}
      hash[:major] = version_parts[PARTS::MAJOR].to_i
      hash[:minor] = version_parts[PARTS::MINOR].to_i
      hash[:patch] = version_parts[PARTS::PATCH].to_i

      hash
    end



    protected

    def bump_major value
      value = value || self.parts[:major] + 1
      FileManager.write [value, 0, 0].join DELIMITER
    end


    def bump_minor value
      value = value || self.parts[:minor] + 1
      FileManager.write [self.parts[:major], value, 0].join DELIMITER
    end


    def bump_patch value
      value = value || self.parts[:patch] + 1
      FileManager.write(
        [self.parts[:major], self.parts[:minor], value].join DELIMITER)
    end

  end

end
