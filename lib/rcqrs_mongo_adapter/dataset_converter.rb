module RcqrsMongoAdapter
  
  class DatasetConverter
    
    def initialize(converters = RcqrsMongoAdapter::Converters)
      @converters = converters
    end
    
    def convert data_set
      get_converter_for(data_set.class).convert(data_set)
    end
    
    def get_converter_for clazz
      @converters.each do |c|
         return c.new(self) if(c.can_convert(clazz))
      end
      return DefaultConverter.new
    end
    
    def convert_back data_set
      get_converter_for(data_set.class).convert_back(data_set)
    end
    
    def do_key_conversion to_convert
      @keyConverter.send(@conversion, to_convert)
    end    
    
  end
  
  class DefaultConverter
    
    def convert data
      data
    end
    
    def convert_back data
      data
    end
    
  end
    
end