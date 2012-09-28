module RcqrsMongoAdapter
  
  class DatasetConverter
    
    def initialize(converters = RcqrsMongoAdapter::Converters)
      @converters = converters
    end
    
    def convert data_set
      get_converter_for(data_set).convert(data_set)
    end
        
    def convert_back data_set
      get_converter_for(data_set, :back).convert_back(data_set)
    end
    
    def get_converter_for data_set, conversion_direction = :forward
      @converters.each do |c|
         return c.new(self) if(c.can_convert(data_set, conversion_direction))
      end
      return DefaultConverter.new
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