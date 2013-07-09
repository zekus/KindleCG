require 'thor'
require 'KindleCG'

module KindleCG
  class CLI < Thor
    method_option :mountpoint, type: :string, aliases: "-m",
      desc: "specify a different mountpoint for the kindle device"
    method_option :backup, type: :boolean, aliases: "-b",
      desc: "take a backup of the collections before overriding it"
    desc 'generate', 'generate and save the collections'
    def generate
      if options[:mountpoint]
        KindleCG.os_mountpoint = options[:mountpoint]
      end

      check

      kindle = Generator.new
      kindle.generate_collections
      if options[:backup]
        kindle.backup
      end
      kindle.save
    end

    method_option :mountpoint, type: :string, aliases: "-m",
      desc: "specify a different mountpoint for the kindle device"
    desc 'check', 'check if a kindle is attached to the computer'
    def check
      mountpoint = options[:mountpoint] || KindleCG.os_mountpoint

      unless File.directory?(mountpoint)
        raise Thor::Error, "Could not find any kindle attached to #{mountpoint}"
        exit 1
      else
        say "Your kindle is attached to #{mountpoint}. Very good! :)", :green
      end
    end
  end
end
