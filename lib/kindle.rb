#!/usr/bin/env ruby

require 'find'
require 'json'
require_relative 'collections'

class Kindle
  
  def initialize(device_mountpoint, os_mountpoint)
    @device_mountpoint = device_mountpoint
    @os_mountpoint = os_mountpoint
    @collections = Collections.new
  end

  def generate_collection
    generate_tree(os_documents_path)
    @collections
  end

  def generate_tree(path, current_collection = nil)
    Dir.foreach(path) do |item|
      next if item[0] == '.'

      fullpath = [path, item].join("/")
      relativepath = relative_path(fullpath)
      
      if File.directory?(fullpath)
        new_collection = @collections.add(relativepath)
        generate_tree(fullpath, new_collection)
      else
        begin
          @collections.add_item_to_collection(current_collection, fullpath) unless current_collection.nil?
        rescue IOError => e
          next
        end
      end
    end
  end

  def save
    IO.write(os_collections_path, @collections.to_json)
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
