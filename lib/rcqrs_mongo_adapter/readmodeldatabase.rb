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
    
    def find(readmodel,parameters,options = nil)
      if options  
        convert_back(find_with_options(readmodel, parameters,options))
      else
        convert_back(find_without_options(readmodel,parameters))        
      end    
    end
    
    def find_with_options(readmodel, parameters, options)
      options.each do |k,v|
        @database.collection(readmodel.to_s).find(convert(parameters)).send(k,v)
      end        
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
    
    private
    
    def convert(data_set)
      RcqrsMongoAdapter::KeysToStringsConverter.new(data_set).convert()
    end
    
    def convert_back(data_set)
      RcqrsMongoAdapter::KeysToStringsConverter.new(data_set).convert_back()      
    end
    
  end
end