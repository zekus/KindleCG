require 'sectionizer'
require 'mobi'
require 'pdf'
require 'digest'
require 'forwardable'

module KindleCG
  module Ebook

    class EbookError < StandardError; end

    class Ebook
      extend Forwardable

      def_delegators :@metadata, :title, :asin, :type

      def initialize(file)
        @file = file
        @metadata = initialize_metadata(file)
      end

      def hash
        if @metadata.type && @metadata.asin
          "#%s^%s" % [@metadata.asin, @metadata.type]
        else
          folder = File.dirname(@file)
          filename = File.basename(@file)
          "*" + Digest::SHA1.hexdigest([KindleCG.device_mountpoint, folder.match(/(documents).*/)[0], filename].join("/"))
        end
      end

      private

      def initialize_metadata(file)
        case get_extension(file)
        when /(mobi|azw)/
          Mobi.new(file)
        when /(pdf)/
          Pdf.new(file)
        else
          raise EbookError, "Can't handle this book type"
        end
      end

      def get_extension(file)
        @_extension ||= File.basename(file).downcase.split('.')[-1]
      end
    end
  end
end
