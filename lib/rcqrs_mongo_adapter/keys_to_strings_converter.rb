module RcqrsMongoAdapter
  class KeysToStringsConverter
    
    def initialize(data_set)
      @data_set = data_set
    end
    
    def convert
      convert_keys @data_set
    end
    
    def convert_keys data_set
      if(data_set.is_a? Hash)
        result = Hash.new
        data_set.each{|k,v| result[k.to_s] = convert_keys(v)}
        return result      
      elsif(data_set.is_a? Array)
        return data_set.collect {|element| convert_keys(element)}
      end 
      return data_set
    end
  end
end