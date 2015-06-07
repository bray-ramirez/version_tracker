module VersionTracker

  class FileManager

    FILENAME = 'VERSION'


    def self.initialized?
      return File.exist? FILENAME
    end


    def self.read
      raise 'VERSION File does not exist.' unless self.initialized?

      File.read FILENAME
    end


    def self.write version
      File.open(FILENAME, 'w') do |file|
        file.write version
      end
    end

  end

end
