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

  def add_to_collection(collection_name, file)
    @collections[collection_name][:items] << file.hash
  end

  def export
    JSON.generate(@collections)
  end
end
