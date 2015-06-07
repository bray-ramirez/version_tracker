require 'version_tracker'


namespace :version_tracker do


  def bump part
    version_tracker = VersionTracker::Bumper.new
    version_tracker.bump :part => part

    puts version_tracker.version
  end


  desc 'Initialize Version'
  task :initialize do
    VersionTracker::Bumper.new.generate
  end


  desc 'Read Version'
  task :current_version do
    puts VersionTracker::Bumper.new.version
  end


  desc 'Bump Major'
  task :bump_major do
    bump :major
  end


  desc 'Bump Minor'
  task :bump_minor do
    bump :minor
  end


  desc 'Bump Patch'
  task :bump_patch do
    bump :patch
  end

end
