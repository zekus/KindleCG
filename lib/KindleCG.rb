require 'KindleCG/version'
require 'json'
require 'KindleCG/collections'
require 'KindleCG/ebook/ebook'

module KindleCG

  class << self
    attr_writer :device_mountpoint, :os_mountpoint

    def device_mountpoint
      @device_mountpoint ||= Pathname.new '/mnt/us'
    end

    def os_mountpoint
      @os_mountpoint ||= Pathname.new '/Volumes/Kindle'
    end

    def system_path
      device_mountpoint.join('system').to_path
    end

    def documents_path
      device_mountpoint.join('documents').to_path
    end

    def os_documents_path
      os_mountpoint.join('documents').to_path
    end

    def os_collections_path
      os_mountpoint.join('system/collections.json').to_path
    end
  end
  
  class Generator
    def initialize
      @collections = Collections.new
    end

    def generate_collections
      generate_tree(KindleCG.os_documents_path)
      @collections
    end

    def generate_tree(path, current_collection = nil)
      Dir.foreach(path) do |item|
        next if item[0] == '.'

        fullpath = [path, item].join("/")

        if File.directory?(fullpath)
          new_collection = @collections.add(relative_path(fullpath))
          generate_tree(fullpath, new_collection)
        else
          begin
            ebook = Ebook::Ebook.new(fullpath)
            @collections.add_item_to_collection(current_collection, ebook) unless current_collection.nil?
          rescue Ebook::EbookError
            next
          end
        end
      end
    end

    def backup
      FileUtils.cp(KindleCG.os_collections_path, [KindleCG.os_collections_path, 'bak'].join('.'), {preserve: false})
    end

    def save
      IO.write(KindleCG.os_collections_path, @collections.to_json)
    end

    private

    def relative_path(path)
      _path = path.dup
      _path.slice!(KindleCG.os_documents_path + '/')
      _path == KindleCG.os_documents_path ? "" : _path
    end 
  end
end
