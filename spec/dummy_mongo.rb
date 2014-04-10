class DummyMongo
   
  attr_accessor :name, :data, :ordering, :query, :options

  def initialize
    @options = []
  end
    
  def collection(name)
    @name = name
    self
  end
  
  def insert(data, options = {})
    @options << options
    @data = data.inject({}){|memo,(k,v)| memo[k.to_s] = v; memo}
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
