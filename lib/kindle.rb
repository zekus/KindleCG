#!/usr/bin/env ruby

require 'find'
require 'json'
require_relative 'ebook/mobi'
require_relative 'ebook/pdf'
require_relative 'collections'

class Kindle
  
  def initialize(device_mountpoint, os_mountpoint)
    @device_mountpoint = device_mountpoint
    @os_mountpoint = os_mountpoint
    @collections = Collections.new
  end

  def generate_collection
    current_collection = nil

    Find.find(os_documents_path) do |path|
      Find.prune if FileTest.directory?(path) && File.basename(path)[0] == '.'
      next if relative_path(path).empty? || File.basename(path)[0] == '.' 

      if FileTest.directory?(path)
        current_collection = @collections.add(relative_path(path))
      else
        begin
          @collections.add_to_collection(current_collection, path) unless current_collection.nil?
        rescue IOError => e
          next
        end
      end
    end
    @collections
  end

  def save
    IO.write(os_collections_path, @collections.export)
  end

  private

  def relative_path(path)
    _path = path.dup
    _path.slice!(os_documents_path + '/')
    _path == os_documents_path ? "" : _path
  end 

  def system_path
    @device_mountpoint + '/system'
  end

  def documents_path
    @device_mountpoint + '/documents'
  end

  def os_documents_path
    @os_mountpoint + '/documents'
  end

  def os_collections_path
    @os_mountpoint + '/system/collections.json'
  end
end

kindle = Kindle.new("/mnt/us", "/Volumes/Kindle")
kindle.generate_collection
kindle.save
