require_relative 'sectionizer'
require_relative 'mobi'

require 'digest'
require 'forwardable'

module Ebook
  class Ebook

    extend Forwardable

    def_delegators :@metadata, :title, :asin, :type

    def initialize(file)
      @file = file
      @metadata = case get_extension(file)
                  when /(mobi|azw)/
                    Mobi.new(file)
                  when /(pdf)/
                    Pdf.new(file)
                  else
                    raise IOError, "Can't handle this book type"
                  end
    end

    def hash
      if @metadata.type && @metadata.asin
        "#%s^%s" % [@metadata.asin, @metadata.type]
      else
        folder = File.dirname(@file)
        filename = File.basename(@file)
        "*" + Digest::SHA1.hexdigest(['/mnt/us', folder.match(/(documents).*/)[0], filename].join("/"))
      end
    end

    private

    def get_extension(file)
      @_extension ||= File.basename(file).downcase.split('.')[-1]
    end
  end
end
