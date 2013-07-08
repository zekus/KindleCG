require 'thor'
require 'KindleCG'

module KindleCG
  class CLI < Thor
    desc 'generate', 'generate and save the collections'
    def generate
      check

      kindle = Generator.new
      kindle.generate_collections
      kindle.save
    end

    desc 'check', 'check if a kindle is attached to the computer'
    def check
      unless File.directory?(KindleCG.os_mountpoint)
        raise Thor::Error, "Could not find any kindle attached to #{KindleCG.os_mountpoint}"
        exit 1
      else
        say "Your kindle is attached to #{KindleCG.os_mountpoint}. Very good! :)", :green
      end
    end
  end
end
