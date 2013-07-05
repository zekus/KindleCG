require_relative 'ebook/sectionizer'
require_relative 'ebook/mobi'

require 'digest'
require 'forwardable'

module Ebook

  extend Forwardable

  def_delegators :@metadata, :title, :asin, :type

  def initialize(file)
    @metadata = case get_extension(file)
                  when /(mobi|azw)/
                    Ebook::Mobi.new(file)
                  else
                    raise "Can't handle this book type"
                end
  end

  def hash
    if metadata.type
      "#%s^%s" % [metadata.asin, metadata.type]
    else
      "*" + Digest::SHA1.hexdigest(file_path)
    end
  end

  private

  def get_extension(file)
    @_extension ||= File.basename(file).split('.')[-1]
  end
end
