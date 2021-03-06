module RcqrsMongoAdapter
  class Readmodeldatabase

    def initialize(mongo)
      @database = mongo
    end
      
    def insert readmodel, data
      @database.collection(readmodel.to_s).insert(convert(data))
    end
    
    def find_one(readmodel, parameters)
      convert_back(@database.collection(readmodel.to_s).find_one(convert(parameters)))
    end
    
    def find(readmodel,parameters = {},options = nil)
      result = nil
      if options  
        result = convert_back(find_with_options(readmodel, parameters,options))
      else
        result = convert_back(find_without_options(readmodel,parameters))        
      end
      result    
    end
    
    def find_with_options(readmodel, parameters, options)
      result = @database.collection(readmodel.to_s).find(convert(parameters)) 
      options.each do |k,v|
        result = result.send(k,v)
      end
      return result        
    end
    
    def find_without_options(readmodel,parameters)
      @database.collection(readmodel.to_s).find(convert(parameters))
    end
    
    def update(readmodel,selector,data)
      @database.collection(readmodel.to_s).update(convert(selector),convert(data))
    end
    
    def delete_all(readmodel,selector)
      @database.collection(readmodel.to_s).remove(convert(selector))
    end
    
    def count(readmodel,selector)
      @database.collection(readmodel.to_s).count(convert(selector))      
    end
    
    private
    
    def convert(data_set)
      RcqrsMongoAdapter::DatasetConverter.new.convert(data_set)
    end
    
    def convert_back(data_set)
      if(data_set.is_a? Mongo::Cursor)
        data_set = data_set.to_a
      end
      RcqrsMongoAdapter::DatasetConverter.new.convert_back(data_set)      
    end
    
  end
end