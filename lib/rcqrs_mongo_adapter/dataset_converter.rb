module RcqrsMongoAdapter
  
  class DatasetConverter
    
    def initialize(keyConverter, valueConverter)
      @keyConverter = keyConverter
      @valueConverter = valueConverter
    end
    
    def convert data_set
      @conversion = :convert
      convert_keys data_set
    end
    
    def convert_back data_set
      @conversion = :convert_back
      convert_keys data_set
    end

    def convert_keys data_set
      if(data_set.is_a? Hash)
        result = Hash.new
        data_set.each{|k,v| result[do_key_conversion(k)] = convert_keys(v)}
        return result      
      elsif(data_set.is_a? Array)
        return data_set.collect {|element| convert_keys(element)}
      end 
      return data_set
    end
    
    def do_key_conversion to_convert
      @keyConverter.send(@conversion, to_convert)
    end    
    
  end
  
  class SymbolsToStringsConverter
    
    def convert symbol
      symbol.to_s
    end
    
    def convert_back string
      string.to_sym
    end
    
  end
  
end