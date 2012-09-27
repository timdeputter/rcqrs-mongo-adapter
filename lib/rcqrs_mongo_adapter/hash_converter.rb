module RcqrsMongoAdapter
  
  class HashConverter < RcqrsMongoAdapter::BaseConverter
    
    converts Hash
    
    def convert hash
      result = Hash.new
      hash.each{|k,v| result[k.to_s] = @converters.convert(v)}
      return result
    end
    
    def convert_back hash
      result = Hash.new
      hash.each{|k,v| result[k.to_sym] = @converters.convert_back(v)}      
      return result
    end
    
  end

end   
