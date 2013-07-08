require 'thor'
require 'KindleCG'

module KindleCG
  class CLI < Thor
    def generate
      kindle = Generator
      kindle.generate_collection
      kindle.save
    end
  end
end
