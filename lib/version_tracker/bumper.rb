#
#
# Reference:
#   http://semver.org/
#
#

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


    def generate version = nil
      # TODO: Validate version
      raise 'VERSION File already exists.' if FileManager.initialized?

      FileManager.write version || self.version
    end


    def set version = nil
      # TODO: Validate version
      raise 'Version is required.' if version.nil?

      FileManager.write version
    end


    #
    #
    # Options:
    #   :part
    #   :value
    #
    #
    def bump options = {}
      part = options[:part] || :patch

      unless [:major, :minor, :patch].include?(part)
        raise 'Invalid Part Parameter.'
      end


      value = options[:value]
      if value && !value.is_a?(Integer)
        raise TypeError, 'Value should be of Integer Type'
      end

      self.send "bump_#{part}".to_sym, value
    end


    def version
      (FileManager.read if FileManager.initialized?) || INITIAL_VERSION
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

    def bump_version value
      return 'Invalid Version Format.' if BASIC_FORMAT =~ value

      FileManager.write value
    end


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
