require 'thor'
require 'KindleCG'

module KindleCG
  class CLI < Thor
    def generate
      kindle = Generator.new("/mnt/us", "/Volumes/Kindle")
      kindle.generate_collection
      kindle.save
    end
  end
end
