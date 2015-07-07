require 'version_tracker'
require 'rails'

module MyPlugin

  class Railtie < Rails::Railtie
    railtie_name :version_tracker

    rake_tasks do
      load "lib/tasks/version_tracker.rake"
    end
  end

end
