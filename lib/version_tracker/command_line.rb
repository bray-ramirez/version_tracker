require 'errors/version_tracker_error'
require 'version_tracker/bumper'


module VersionTracker

  class CommandLine

    module COMMANDS
      INIT = 'init'
      BUMP = 'bump'
      READ = 'read'
      TAG = 'tag'
    end

    VALID_PARTS = %w(major minor patch)
    DEFAULT_PART = 'patch'
    DEFAULT_COMMIT_MESSAGE = 'Set Version to'
    SUCCESS = 0


    def initialize args, options
      @command = args[0]
      @options = options.merge(:argument => args[1])

      @version_tracker = VersionTracker::Bumper.new
    end


    def execute
      result =
        case @command
        when COMMANDS::INIT
          @version_tracker.init @options[:argument]
          @version_tracker.version
        when COMMANDS::READ
          @version_tracker.version
        when COMMANDS::TAG
          self.git_tag
          'Successfully created tag.'
        when COMMANDS::BUMP
          self.bump
          @version_tracker.version
        end

      self.release if !!@options[:release]
      self.push if !!@options[:push] && !@options[:release]

      [result, SUCCESS]
    rescue VersionTrackerError => e
      return [e.message, 1]
    end





    protected

    def git_tag
      result = system("git tag #{@version_tracker.version}")
      raise VersionTrackerError, 'Failed to create tag' unless result

      system("git push origin #{@version_tracker.version}")
      raise VersionTrackerError, 'Failed to create tag' unless result
    end


    def bump
      part = @options[:argument] || DEFAULT_PART
      raise VersionTrackerError, 'Invalid Part' if VALID_PARTS.include?(part)

      @version_tracker.bump :part => part.to_sym
    end


    def release
      branch = ['release', @version_tracker.version].join '/'

      exists = system "git rev-parse --verify #{branch}"
      create_branch = '-b' unless exists

      system ['git', 'checkout', create_branch, branch].join(' ')
      self.git_commit branch
    end


    def push
      result = `git rev-parse --abbrev-ref HEAD`
      branch = result.gsub /\n/, ''
      self.git_commit branch
    end


    def message
      @options[:message] || [DEFAULT_COMMIT_MESSAGE, @version_tracker.version].join(' ')
    end


    def git_commit branch
      system 'git add VERSION'
      system "git commit -m '#{self.message}'"
      system "git push origin #{branch}"
    end

  end

end
