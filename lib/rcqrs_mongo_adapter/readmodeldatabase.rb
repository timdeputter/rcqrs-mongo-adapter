module RcqrsMongoAdapter
  class Readmodeldatabase

    def initialize(mongo)
      @database = mongo
    end
      
    def insert readmodel, data
      @database.collection(readmodel.to_s).insert(data)
    end
    
    def find_one(readmodel, parameters)
      @database.collection(readmodel.to_s).find_one(parameters)
    end
    
    def find(readmodel,parameters,options = nil)
      if options  
        @database.collection(readmodel.to_s).find(parameters,options)
      else
        @database.collection(readmodel.to_s).find(parameters)        
      end    
    end
    
    def update(readmodel,selector,data)
      @database.collection(readmodel.to_s).update(selector,data)
    end
    
    def delete_all(readmodel,selector)
      @database.collection(readmodel.to_s).remove(selector)
    end
    
  end
end