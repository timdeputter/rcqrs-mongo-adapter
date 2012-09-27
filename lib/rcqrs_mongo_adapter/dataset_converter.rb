module RcqrsMongoAdapter
  
  class DatasetConverter
    
    def initialize()
      @converters = [RcqrsMongoAdapter::HashConverter,
        RcqrsMongoAdapter::ArrayConverter,
        RcqrsMongoAdapter::DateConverter]
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
  
  class BaseConverter
    
    class << self
      def converts type
        @converts = type
      end
      
      def can_convert type
        @converts == type
      end
    end    
    
    def initialize converters
      @converters = converters
    end
    
    def can_convert clazz
      self.class.can_convert(clazz)
    end

  end
  
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
  
  class ArrayConverter < RcqrsMongoAdapter::BaseConverter
    
    converts Array
    
    def convert array
      array.collect {|element| @converters.convert(element)}.to_a
    end
    
    def convert_back array
      array.collect {|element| @converters.convert_back(element)}.to_a      
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