class DummyMongo
   
  attr_accessor :name, :data, :ordering, :query
    
  def collection(name)
    @name = name
    self
  end
  
  def insert(data)
    @data = data
  end
  
  def find(query)
    @query = query
    self
  end

  def sort(ordering)
    @ordering = ordering
    [@data]
  end
end
