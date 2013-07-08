module KindleCG
  class Collections
    attr_reader :collections

    def initialize
      @collections = {}
    end

    def add(name, language = 'en-US')
      collection_name = "#{name}@#{language}"
      @collections[collection_name] = { items: [] } 
      collection_name
    end

    def add_item_to_collection(collection_name, ebook)
      @collections[collection_name][:items] << ebook.hash
    end

    def to_json
      JSON.generate(@collections)
    end
  end
end
