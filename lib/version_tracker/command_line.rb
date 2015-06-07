require 'version_tracker/bumper'


module VersionTracker

  class CommandLine
    #
    #
    # Options:
    #   init
    #   version
    #
    #
    def initialize options = {}
      @bumper = VersionTracker::Bumper.new
      @options = options
    end


    def execute
      return self.init_version if @options[:init]
    end





    protected

    def init_version
      @bumper.generate
      self.display_result
    end


    def set_version
      @bumper.generate options[:version]
      self.display_result
    end


    def display_result
      puts "Version: #{@bumper.version}"
    end

  end

end
